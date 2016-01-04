global class BatchGenerateTimesheets implements Database.Batchable<sObject>{

    global string query = 'SELECT Id,Name from User where Time_Study_User__c = TRUE and isActive = TRUE';

    map<Id, List<Task>> userTaskMap; 
    map<Id, List<Event>> userEventMap;
    map<Id, Timesheet__c> timesheetMap;
    map<string,Time_Sheet_Activity__c> activityMap;
    
    // do I need this??
    List<Timesheet__c> insertTimesheetList;
    
    
    DateTime startDate;
    DateTime endDate; 
    Date baseMonday = date.newInstance(1900,1,8);   

    global BatchGenerateTimesheets() {
        // check if I'm a monday
        if(Math.MOD(baseMonday.daysBetween(Date.Today()),7) == 0) {
            system.debug('its monday');
        } else {
            // throw an error
        }
        
        startDate = Datetime.newInstance(Date.today(), Time.newInstance(0,0,0,0));
        endDate = DateTime.newInstance(startDate.addDays(7).date(), Time.newInstance(23,59,59,59));
    }
    
    global BatchGenerateTimesheets(Date runDate) {
        startDate = Datetime.newInstance(runDate, Time.newInstance(0,0,0,0));
        endDate = DateTime.newInstance(startDate.addDays(7).date(), Time.newInstance(23,59,59,59));
    }         


    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope) {

        // TODO:: wrap this in a big try-catch

        prepare(scope);        


///////  map over each user and create the timesheets;

        for(User each : (List<User>)scope) {
            // check if there's a timesheet
            if(timesheetMap.containsKey(each.Id) == FALSE) {
                Timesheet__c ts = new Timesheet__c();
                ts.OwnerId = each.id;
                ts.week_commencing__c = startDate.date();
                timesheetMap.put(each.Id, ts);
                
           } 
 
            
        }
        upsert timesheetMap.values();



        for(Timesheet__c eachTimesheet : timeSheetMap.values()) {
            // populate the timesheet activities

            if(userTaskMap.containsKey(eachTimesheet.OwnerId)) {           
                for (Task eachTask : userTaskMap.get(eachTimesheet.OwnerId)) {
                    string mapkey = eachTask.Type + eachTask.OwnerId + eachTask.Account.tfCrmCountry__c + eachTask.Account.Id + eachTask.Product_Family_A_M__c;
                    if(activityMap.containsKey(mapkey)) {
                        Time_Sheet_Activity__c activity = activityMap.get(mapkey);
                        // what to do here??
                        activity.Mon__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 0)    ? activity.Mon__c + 1 :activity.Mon__c;
                        activity.Mon__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 1)    ? activity.Tue__c + 1 :activity.Tue__c;
                        activity.Wed__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 2)    ? activity.Wed__c + 1 :activity.Wed__c;
                        activity.Thur__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 3)   ? activity.Thur__c + 1 :activity.Thur__c;
                        activity.Fri__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 4)    ? activity.Fri__c + 1 :activity.Fri__c;
                        activity.Sat__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 5)    ? activity.Sat__c + 1 :activity.Sat__c;
                        activity.Sun__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 6)    ? activity.Sun__c + 1 :activity.Sun__c;
    
                    } else {
                        Time_Sheet_Activity__c activity = new Time_Sheet_Activity__c(Timesheet__c = eachTimesheet.Id);
                        activity.Country__c = eachTask.Account.tfCrmCountry__c;
                        activity.Account__c = eachTask.Account.Id;
                        activity.Activity_Type__c = (eachTask.Type == 'Internal Activity') ? 'Non-Client Facing':'Client Facing';
                        activity.Sub_Activity_Type__c = eachTask.Type;
                        activity.Product__c = eachTask.Product_Family_A_M__c;
                        activity.Mon__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 0)    ? 1 :0;
                        activity.Tue__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 1)    ? 1 :0;
                        activity.Wed__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 2)    ? 1 :0;
                        activity.Thur__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 3)   ? 1 :0;
                        activity.Fri__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 4)    ? 1 :0;
                        activity.Sat__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 5)    ? 1 :0;
                        activity.Sun__c = (baseMonday.daysBetween(eachTask.ActivityDate) == 6)    ? 1 :0;
 
                         // put it in the map
                        activityMap.put(mapkey,activity);
                    }
                    
                    // tie it to the timesheet
                    eachTask.Timesheet__c = eachTimesheet.Id;            
                
                }
            
            }
            
            //look for events and tie them to days
            //look for tasks and tie them to days
            // do whatever to dedupe
          
            
            
        }


    }


    global void finish(Database.BatchableContext bc) {
    
    }

    void prepare(List<SObject> scope) {
        userTaskMap = new map<Id, List<Task>>();
        for(Task eachTask : [select Id, ownerId, ActivityDate, Account.Id, Type, Product_Family_A_M__c,Account.tfCrmCountry__c from Task where ownerId in :scope AND createddate >= :startDate and createddate <= :endDate and Timesheet__c = null]) {
            if (userTaskMap.containsKey(eachTask.ownerId) == FALSE) {
                userTaskMap.put(eachTask.ownerId, new List<Task> {eachTask});
            } else {
                userTaskMap.get(eachTask.ownerId).add(eachTask);
            }
        }

        userEventMap = new map<Id, List<Event>>();
        for(Event eachEvent : [select Id, ownerId, Account.Id, Type, Product_Family_A_M__c,Account.tfCrmCountry__c from Event where ownerId in :scope AND createddate >= :startDate and createddate <= :endDate and Timesheet__c = null]) {
            if (userEventMap.containsKey(eachEvent.ownerId) == FALSE) {
                userEventMap.put(eachEvent.ownerId, new List<Event> {eachEvent});
            } else {
                userEventMap.get(eachEvent.ownerId).add(eachEvent);
            }
        }    
        

        timeSheetMap = new map<Id,Timesheet__c>();
        for(Timesheet__c eachTimesheet : [select Id, OwnerId from Timesheet__c where ownerId in :scope AND Week_Commencing__c >= :startDate.Date() AND Week_Commencing__c <= :endDate.Date()]) {
            timesheetMap.put(eachTimesheet.OwnerId, eachTimesheet);
        }    
    
    }

    
    
}