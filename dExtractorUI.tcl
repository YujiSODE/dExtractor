#dExtractor
#dExtractorUI.tcl
##===================================================================
#	Copyright (c) 2017 Yuji SODE <yuji.sode@gmail.com>
#
#	This software is released under the MIT License.
#	See LICENSE or http://opensource.org/licenses/mit-license.php
##===================================================================
#Simple data extraction tool.
#User Interface of "dExtractor.tcl".
##===================================================================
set auto_noexec 1;
package require Tcl 8.6;
source dExtractor.tcl;
proc dExUI {} {
	#=== <namespace: dEx_UI> ===
	namespace eval ::dEx_UI {
		#idx is array index
		variable idx {};
		#*** Commands ***
		#it ends this program
		proc @exit {} {
			#!++++test output++++
			variable ::dEx::DATA;variable ::dEx::V;
			puts "DATA: $DATA";
			if {[array size V]} {parray V;};
			#!+++++++++++++++++++
			exit;
		};
		#it loads additional Tcl script
		proc @src {filePath} {
			# - $filePath: file path of Tcl script to load
			source $filePath;
		};
		#it resets internal parameters
		proc @reset {} {
			::dEx::reset;
			set ::dEx_UI::idx {};
		};
		#it sets data title
		proc @title {TITLE} {
			# - $TITLE: new title name
			::dEx::title $TITLE;
		};
		#it reads a file as sample and updates sample counted data
		#if all arguments are omitted then it only updates counted data
		proc @read {{filePath {}} {char {}} {numerical 0} {encoding {}}} {
			# - $filePath: file path of file to load
			# - $char: split characters; standard white-space characters is default setting
			# - $numerical: boolean (0|1) indicates if it regards data as numerical data; 0 is default value
			# - $encoding: encoding name
			variable idx;
			if {[llength $filePath]} {
				::dEx::dRead $filePath $char $encoding;
			};
			set idx [::dEx::count $::dEx::DATA $numerical];
		};
		#it makes a graph as ASCII art
		proc @graph {{dx 1} {min 0} {char \#}} {
			#a block is a unit for dealing with data frequency
			# - $dx: a number (!$dx<1) that represents a value which is equivalent to a block in a graph; 1 is default value
			# - $min: the least value (!$min<0) to show in a graph; 0 is default value
			# - $char: a character that is used as a block in a graph; "\#" is default value
			#idx is array index; a list of element names that is referred wile using counted array ($::dEx::V)
			variable idx;
			if {[llength $idx]} {
				puts stdout [::dEx::graph $idx $dx $min $char];
			} else {
				puts stdout "Array index is invalid.\nPlease call \"@read\" to update array index.";
			};
		};
		proc @help {} {
			#it shows a list of help
			puts stdout "- @help\n\tit shows this help.";
			puts stdout "- @exit\n\tit ends this program.";
			puts stdout "- @src filePath\n\tit loads additional Tcl script.\n\t - \$filePath: file path of Tcl script to load";
			puts stdout "- @reset\n\tit resets internal parameters.";
			puts stdout "- @title TITLE\n\tit sets data title.\n\t - \$TITLE: new title name";
			puts stdout "- @read ?filePath? ?char? ?numerical? ?encoding?\n\tit reads a file as sample and updates sample counted data.\n\tif all arguments are omitted then it only updates counted data.\n\t - \$filePath: file path to read\n\t - \$char: split characters; standard white-space is default setting\n\t - \$numerical: boolean (0|1) indicates if it regards data as numerical data; 0 is default value\n\t - \$encoding: encoding name";
			puts stdout "- @graph ?dx? ?min? ?char?\n\tit makes a graph as ASCII art.\n\t a block is a unit for dealing with data frequency\n\t - \$dx: a number (!\$dx<1) that represents a value which is equivalent to a block in a graph; 1 is default value\n\t - \$min: the least value (!\$min<0) to show in a graph; 0 is default value\n\t - \$char: a character that is used as a block in a graph; \"\#\" is default value";
		};
		#*** Main procedure ***
		proc UI_input {} {
			set i 0;
			#loading variables in namespace: dEx; $FILES and $DATA are a list of input names and a list of raw data
			variable ::dEx::FILES;variable ::dEx::DATA;
			puts stdout "=== dExtractor ===\n@help: to show help\; @exit: to end this program";
			#X is input
			gets stdin X;
			switch -exact [lindex $X 0] {
				@exit {
					#it ends this program
					::dEx_UI::@exit;
				}
				@src {
					#it loads additional Tcl script
					::dEx_UI::@src [lindex $X 1];
					::dEx_UI::UI_input;
				}
				@reset {
					#it resets internal parameters
					::dEx_UI::@reset;
					::dEx_UI::UI_input;
				}
				@title {
					#it sets data title
					::dEx_UI::@title [lindex $X 1];
					::dEx_UI::UI_input;
				}
				@read {
					#it reads a file as sample and updates sample counted data
					eval ::dEx_UI::@read [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@graph {
					#it makes a graph as ASCII art
					eval ::dEx_UI::@graph [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@help {
					#it shows a list of help
					::dEx_UI::@help;
					::dEx_UI::UI_input;
				}
				default {
					#addition of inputs to a list of read data
					set i 0;
					foreach e $X {
						if {$i<1} {lappend FILES "input:[string map {\u20 _} [clock format [clock seconds] -gmt 1]]";};
						if {![regexp {^(?:)$} $e]} {lappend DATA $e;};
						incr i 1;
					};
					::dEx_UI::UI_input;
				}
			};
		};
	};
	::dEx_UI::UI_input;
};
dExUI;