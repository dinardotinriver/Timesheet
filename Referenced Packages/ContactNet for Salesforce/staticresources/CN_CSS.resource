.meter {
	height: 6px;  /* Can be anything */
	position: relative;
	margin: 0px 0 0px 0; /* Just for demo spacing */
	background: #C0C0C0;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border-radius: 5px;
	padding: 2px;
	-webkit-box-shadow: inset 0 -1px 1px rgba(255,255,255,0.3);
	-moz-box-shadow   : inset 0 -1px 1px rgba(255,255,255,0.3);
	box-shadow        : inset 0 -1px 1px rgba(255,255,255,0.3);
}
.meter > span {
	display: block;
	height: 100%;
	   -webkit-border-top-right-radius: 2px;
	-webkit-border-bottom-right-radius: 2px;
	       -moz-border-radius-topright: 2px;
	    -moz-border-radius-bottomright: 2px;
		   border-top-right-radius: 2px;
		border-bottom-right-radius: 2px;
	    -webkit-border-top-left-radius: 2px;
	 -webkit-border-bottom-left-radius: 2px;
		-moz-border-radius-topleft: 2px;
	     -moz-border-radius-bottomleft: 2px;
		    border-top-left-radius: 2px;
		 border-bottom-left-radius: 2px;
	background-color: rgb(43,194,83);
	background-image: -webkit-gradient(
	  linear,
	  left bottom,
	  left top,
	  color-stop(0, rgb(43,194,83)),
	  color-stop(1, rgb(84,240,84))
	 );
	background-image: -moz-linear-gradient(
	  center bottom,
	  rgb(43,194,83) 37%,
	  rgb(84,240,84) 69%
	 );
	-webkit-box-shadow:
	  inset 0 2px 2px  rgba(255,255,255,0.3),
	  inset 0 -2px 2px rgba(0,0,0,0.4);
	-moz-box-shadow:
	  inset 0 2px 2px  rgba(255,255,255,0.3),
	  inset 0 -2px 2px rgba(0,0,0,0.4);
	box-shadow:
	  inset 0 2px 2px  rgba(255,255,255,0.3),
	  inset 0 -2px 2px rgba(0,0,0,0.4);
	position: relative;
	overflow: hidden;
}
.meter > span:after, .animate > span > span {
	content: "";
	position: absolute;
	top: 0; left: 0; bottom: 0; right: 0;
	background-image:
	   -webkit-gradient(linear, 0 0, 100% 100%,
	      color-stop(.25, rgba(255, 255, 255, .2)),
	      color-stop(.25, transparent), color-stop(.5, transparent),
	      color-stop(.5, rgba(255, 255, 255, .2)),
	      color-stop(.75, rgba(255, 255, 255, .2)),
	      color-stop(.75, transparent), to(transparent)
	   );
	background-image:
		-moz-linear-gradient(
		  -45deg,
	      rgba(255, 255, 255, .2) 25%,
	      transparent 25%,
	      transparent 50%,
	      rgba(255, 255, 255, .2) 50%,
	      rgba(255, 255, 255, .2) 75%,
	      transparent 75%,
	      transparent
	   );
	z-index: 1;
	-webkit-background-size: 3px 3px;
	-moz-background-size: 3px 3px;
	-webkit-animation: move 2s linear infinite;
	   -webkit-border-top-right-radius: 2px;
	-webkit-border-bottom-right-radius: 2px;
	       -moz-border-radius-topright: 2px;
	    -moz-border-radius-bottomright: 2px;
		   border-top-right-radius: 2px;
		border-bottom-right-radius: 2px;
	    -webkit-border-top-left-radius: 2px;
	 -webkit-border-bottom-left-radius: 2px;
		-moz-border-radius-topleft: 2px;
	     -moz-border-radius-bottomleft: 2px;
		    border-top-left-radius: 2px;
		 border-bottom-left-radius: 2px;
	overflow: hidden;
}

.animate > span:after {
	display: none;
}

@-webkit-keyframes move {
    0% {
       background-position: 0 0;
    }
    100% {
       background-position: 50px 50px;
    }
}

.orange > span {
	background-color: #f1a165;
	background-image: -moz-linear-gradient(top, #f1a165, #f36d0a);
	background-image: -webkit-gradient(linear,left top,left bottom,color-stop(0, #f1a165),color-stop(1, #f36d0a));
	background-image: -webkit-linear-gradient(#f1a165, #f36d0a);
}

.red > span {
	background-color: #f0a3a3;
	background-image: -moz-linear-gradient(top, #f0a3a3, #f42323);
	background-image: -webkit-gradient(linear,left top,left bottom,color-stop(0, #f0a3a3),color-stop(1, #f42323));
	background-image: -webkit-linear-gradient(#f0a3a3, #f42323);
}

.nostripes > span > span, .nostripes > span:after {
	-webkit-animation: none;
	background-image: none;
}
		
div.htmltooltip{
	position: absolute; /*leave this alone*/
	display: none; /*leave this alone*/
	width: 300px;
	left: 0; /*leave this alone*/
	top: 0; /*leave this alone*/
	background: lightyellow;
	border: 2px solid gray;
	border-width: 1px 2px 2px 1px;
	padding: 5px;
}	

.tableHeader {
	background-color: #B4B0B0;
}

.TableCellEvenBackground {
	border-color: #C6C2C2;
	border-width: 0 0 1px 0;
	border-style: solid;
}

table.innerTableStyle {
	border-width: 0px;
	border-spacing: 2px;
	border-style: none;
	border-color: black;
	border-collapse: collapse;
	background-color: #FAF8F8;
}

table.innerTableStyle td {
	border-width: 1px;
	padding: 2px;
	border-style: inset;
	border-color: gray;
	background-color: #FAF8F8;
	-moz-border-radius: ;
}

.selectedTab {
	font-weight:bold;
	font-size:12px;
}

.tabBodyStyle {
	font-size: 11px;
}
.tabHeaderStyle {
	font-size: 12px;
}