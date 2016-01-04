a:hover {
  /* background:#ffffff; BG color is a must for IE6*/ 
  text-decoration:none;
}
a.hoverTooltip span {
  display:none;
  padding:2px 3px;
  margin-left:8px;
  width:auto;
}
a.hoverTooltip:hover span {
  display:inline;
  position:absolute;
  z-index:9999;
  background:#FFC;
  border:1px solid #cccccc;
  color:#000000;
}
a.hoverTooltip img {
  position: relative;
  z-index:1;
  vertical-align: top;
  margin-top:3px;
  display:none;
}

/* Accept Correction Dialog */
.dialog-msg {  
  margin: 5px 0px;
  padding: 5px;
  border: silver 1px solid;
  border-radius: 7px;
  background: #ebaf59; 
}

.address-item { 
  display: block;
  padding: 5px; 
}

.address-item:hover {
  background: #FFFFD4;   
  padding: 5px; 
  border-radius: 7px; 
}

.item-container {
  padding: 5px; 
  display:inline-block;
  border: 1px;
  width: 98%;
}

.item-container .item-header {
  width: 100%;
  display:inline-block;
  font-weight:bold;
  font-size: 17px;
  line-height: 26px;
  border-bottom: 1px solid gray;
}

.item-container .check-control {
  display:block;
  margin: 5px;
}

.check-control .checkbox {
  margin-top: 60px;
  display: inline-block;	
  float: left;
  height: 100px; 
  width: 30px; 
}

.check-control .container {
  display: block;
}

.container span {
  display:inline-block; 
  line-height: 24px;
  overflow: hidden; 
  text-overflow: ellipsis;
  height: 24px;
  word-wrap: break-word;
  white-space: nowrap;
}

.container .label{
  width: 125px;
  font-weight: bold;
}

.container .oldvalue{
  width: 200px;
  max-width: 215px;
}

.container .newvalue{
  width: 205px;
  padding-left: 15px;
}

.control .header {
  font-weight:bold;
  line-height:18px;
  color: gray; 
}

.trow {
  margin: 5px;
}

.trow:hover {
  background-color: grey;
}

td .container {
  display: block;
}

td .container span {
  display: inline-block;
}
 
td .container .label{
  width: 130px;
  font-weight: bold;
}

td .container .oldvalue{
  width: 200px;
}

.oldvalue.changed {
  color: blue;
 }

td .container .newvalue{
  width: 200px;
}

.newvalue.changed {
  color: blue;
}

table .hidden{
  display:none;
}
