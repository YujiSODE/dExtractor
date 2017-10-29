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
			# - $numerical: boolean (0|1) that indicates if it regards data as numerical data; 0 is default value
			# - $encoding: encoding name
			variable idx;variable ::dEx::NUM;
			if {[llength $filePath]} {
				::dEx::dRead $filePath $char $encoding;
				set idx [::dEx::count $::dEx::DATA $numerical];
			} else {
				set idx [::dEx::count $::dEx::DATA $NUM];
			};
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
		#*** Commands to output ***
		#it outputs raw data list
		proc @output_DATA {filePath {char \t} {encoding {}}} {
			# - $filePath: file path of file to output
			# - $char: separating characters; tab character is default value
			# - $encoding: encoding name
			::dEx::output_DATA $filePath $char $encoding;
		};
		#it outputs filename list
		proc @output_FILES {filePath {char \t} {encoding {}}} {
			# - $filePath: file path of file to output
			# - $char: separating characters; tab character is default value
			# - $encoding: encoding name
			::dEx::output_FILES $filePath $char $encoding;
		};
		#it outputs elements list in a counted array
		proc @output_elements {filePath {char \t} {encoding {}}} {
			# - $filePath: file path of file to output
			# - $char: separating characters; tab character is default value
			# - $encoding: encoding name
			::dEx::output_elements $filePath $char $encoding;
		};
		#it outputs a graph table
		proc @output_table {filePath {char \t} {encoding {}}} {
			# - $filePath: file path of file to output
			# - $char: separating characters; tab character is default value
			# - $encoding: encoding name
			::dEx::output_table $filePath $char $encoding;
		};
		#it outputs graph result as ASCII art
		proc @output_GRAPH {filePath {encoding {}}} {
			# - $filePath: file path of file to output
			# - $encoding: encoding name
			::dEx::output_GRAPH $filePath $encoding;
		};
		#it outputs log of the current values as tcl script
		proc @log {filePath {encoding {}}} {
			# - $filePath: file path of file to output
			# - $encoding: encoding name
			::dEx::log $filePath $encoding;
		};
		#it shows a list of help
		proc @help {} {
			puts stdout "- @help\n\tit shows this help.\n";
			puts stdout "- @exit\n\tit ends this program.\n";
			puts stdout "- @src filePath\n\tit loads additional Tcl script.\n\t - \$filePath: file path of Tcl script to load\n";
			puts stdout "- @reset\n\tit resets internal parameters.\n";
			puts stdout "- @title TITLE\n\tit sets data title.\n\t - \$TITLE: new title name\n";
			puts stdout "- @read ?filePath? ?char? ?numerical? ?encoding?\n\tit reads a file as sample and updates sample counted data.\n\tif all arguments are omitted then it only updates counted data.\n\t - \$filePath: file path to read\n\t - \$char: split characters; standard white-space is default setting\n\t - \$numerical: boolean (0|1) indicates if it regards data as numerical data; 0 is default value\n\t - \$encoding: encoding name\n";
			puts stdout "- @graph ?dx? ?min? ?char?\n\tit makes a graph as ASCII art.\n\t a block is a unit for dealing with data frequency\n\t - \$dx: a number (!\$dx<1) that represents a value which is equivalent to a block in a graph; 1 is default value\n\t - \$min: the least value (!\$min<0) to show in a graph; 0 is default value\n\t - \$char: a character that is used as a block in a graph; \"\#\" is default value\n";
			puts stdout "- @ TITLE\n\tit sets data title.\n\t - \$TITLE: new title name\n";
			puts stdout "- @output_help\n\tit shows a help of output.\n";
		};
		#it shows a help of output
		proc @output_help {} {
			puts stdout "- @output_DATA filePath ?char? ?encoding?\n\tit outputs raw data list.\n\t - \$filePath: file path of file to output\n\t - \$char: separating characters; tab character is default value\n\t - \$encoding: encoding name\n";
			puts stdout "- @output_FILES filePath ?char? ?encoding?\n\tit outputs filename list.\n\t - \$filePath: file path of file to output\n\t - \$char: separating characters; tab character is default value\n\t - \$encoding: encoding name\n";
			puts stdout "- @output_elements filePath ?char? ?encoding?\n\tit outputs elements list in a counted array.\n\t - \$filePath: file path of file to output\n\t - \$char: separating characters; tab character is default value\n\t - \$encoding: encoding name\n";
			puts stdout "- @output_table filePath ?char? ?encoding?\n\tit outputs a graph table.\n\t - \$filePath: file path of file to output\n\t - \$char: separating characters; tab character is default value\n\t - \$encoding: encoding name\n";
			puts stdout "- @output_GRAPH filePath ?encoding?\n\tit outputs graph result as ASCII art.\n\t - \$filePath: file path of file to output\n\t - \$encoding: encoding name\n";
			puts stdout "- @log filePath ?encoding?\n\tit outputs log of the current values as tcl script.\n\t - \$filePath: file path of file to output\n\t - \$encoding: encoding name\n";
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
				@output_DATA {
					#it outputs raw data list
					eval ::dEx_UI::@output_DATA [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@output_FILES {
					#it outputs filename list
					eval ::dEx_UI::@output_FILES [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@output_elements {
					#it outputs elements list in a counted array
					eval ::dEx_UI::@output_elements [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@output_table {
					#it outputs a graph table
					eval ::dEx_UI::@output_table [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@output_GRAPH {
					#it outputs graph result as ASCII art
					eval ::dEx_UI::@output_GRAPH [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@log {
					#it outputs log of the current values as tcl script
					eval ::dEx_UI::@log [lrange $X 1 end];
					::dEx_UI::UI_input;
				}
				@help {
					#it shows a list of help
					::dEx_UI::@help;
					::dEx_UI::UI_input;
				}
				@output_help {
					#it shows a help of output
					::dEx_UI::@output_help;
					::dEx_UI::UI_input;
				}
				@output {
					#it shows a help of output
					::dEx_UI::@output_help;
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
