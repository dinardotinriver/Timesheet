public with sharing class TimesheetController {

    public Timesheet__c timesheet {get; set;}
    public List<TSWrapper> activityList;
    public List<Time_Sheet_Activity__c> deleteList {get; set;}
    
    
    public TimesheetController(ApexPages.StandardController controller) {
        controller.addfields(new list<string>{'Status__c'});
        this.timesheet = (Timesheet__c)controller.getRecord();
        
    }

    public List<TSWrapper> getActivityList() {
        deleteList = new List<Time_Sheet_Activity__c>();
        if (activityList == null) {
            activityList = new List<TSWrapper>();
            for (Time_Sheet_Activity__c eachActivity : [select name, Activity_Type__c, Country__c, Fri__c, Industry_Class__c, Account__c,
            Mon__c, Product__c, Sat__c, Sun__c, Thur__c, Tue__c, Wed__c, Total_Line_Activity__c,Sub_Activity_Type__c
              from Time_Sheet_Activity__c
              where Timesheet__c = :this.timesheet.Id]) {
                  activityList.add(new TSWrapper(eachActivity, activityList.size()));
              }
            

        }
        if (activityList.size() == 0) {
            activityList.add(new TSWrapper(addActivity(), activityList.size()));
        }
        
        return activityList;
    }

    public PageReference addRow() {
        activityList.add(new TSWrapper(addActivity(), activityList.size()));
        return null;
    }

    public Pagereference deleteRow() {
        // activityList.add(addActivity());
        return null;
    }

    private Time_Sheet_Activity__c addActivity() {
        Time_Sheet_Activity__c tsa = new Time_Sheet_Activity__c(timesheet__c = timesheet.Id,
            mon__c=0, tue__c=0,wed__c=0,thur__c=0,fri__c=0,sat__c=0,sun__c=0);
        return tsa;
    }



    public PageReference saveAll() {
        try {
            upsert timesheet;
            // remove nulls
            
            List<Time_Sheet_Activity__c> upsertList = new List<Time_Sheet_Activity__c>();
            // List<Time_Sheet_Activity__c> deleteList = new List<Time_Sheet_Activity__c>();
            
            for (TSWrapper wrapper : activityList) {
                if(wrapper.del != true  && sumHours(wrapper.rec) > 0 && wrapper.rec.account__c != null) {
                    upsertList.add(wrapper.rec);
                } else if (wrapper.rec.Id != null) {
                    deleteList.add(wrapper.rec);
                }
            
            }
            upsert upsertList;
            delete deleteList;
            getActivityList();

            PageReference tsPage = new ApexPages.StandardController(timesheet).edit();
            tsPage.setRedirect(true);
            return tsPage;


        } catch (Exception e) {           
            system.debug(e);
            return null;
        }

    }
    
    public Class TsWrapper {
        public boolean del {get; set;}
        public Integer num {get; set;}
        public Time_Sheet_Activity__c rec {get; set;}
        
        public TsWrapper(Time_Sheet_Activity__c rec, Integer num) {
            del = false;
            this.rec = rec;
            this.num = num;
        }
    
    
    }
    
    
    private Decimal sumHours (Time_Sheet_Activity__c tsa) {
        return ifnull(tsa.mon__c) + ifnull(tsa.tue__c) + ifnull(tsa.wed__c) 
            + ifnull(tsa.thur__c) + ifnull(tsa.fri__c) + ifnull(tsa.sat__c) + ifnull(tsa.sun__c);
 
    }

    private Decimal ifnull(Decimal integ) {
        return (integ == null) ? 0 : integ; 
    }    
}