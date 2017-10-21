#dExtractor
#dExtractor.tcl
##===================================================================
#	Copyright (c) 2017 Yuji SODE <yuji.sode@gmail.com>
#
#	This software is released under the MIT License.
#	See LICENSE or http://opensource.org/licenses/mit-license.php
##===================================================================
#Simple data extraction tool.
#=== <Namespace: dEx> ===
	#== Values ==
		# - $TITLE: a title of data set
		# - $FILES: a list of input filenames
		# - $DATA: a list of raw data
		# - $GRAPH: a list of graph parts
		# - $V: an array of counted data; element names in this array are encoded with base64
	#== Main procedures ==
		# - reset;
			#it resets internal parameters
		#
		# - title txt;
			#it sets title as $txt
		#
		# - dRead filePath ?char? ?encoding?;
			#it reads data from a file
			# - $filePath: file path of file to load
			# - $char: split characters; standard white-space characters is default value
			# - $encoding: encoding name
		#
		# - count l ?numerical?;
			#it counts elements in given list and returns a list of element names
			# - $l: a list
			# - $numerical: boolean (0|1) indicates if it regards data as numerical data; 0 is default value
		#
		# - graph elements ?dx? ?min? ?char?;
			#it makes a graph as ascii art
			#a block is a unit for dealing with data frequency
			# - $elements: a list of element names that is referred wile using counted array ($::dEx::V)
			# - $dx: a number (!$dx<1) that represents a value which is equivalent to a block in a graph; 1 is default value
			# - $min: the least value (!$min<0) to show in a graph; 0 is default value
			# - $char: a character that is used as a block in a graph; "\#" is default value
		#
		# - output_DATA filePath ?char? ?encoding?;
			#it outputs raw data list
			# - $filePath: file path of file to output
			# - $char: separating characters; tab character is default value
			# - $encoding: encoding name
		#
		# - output_FILES filePath ?char? ?encoding?;
			#it outputs filename list
			#see "output_DATA" for parameters
		#
		# - output_elements filePath ?char? ?encoding?;
			#it outputs elements list in a counted array
			#see "output_DATA" for parameters
		#
		# - output_table filePath ?char? ?encoding?;
			#it outputs a graph table
			#see "output_DATA" for parameters
		#
		# - log filePath ?encoding?;
			#it outputs log of the current values as tcl script
			# - $filePath: file path of file to output
			# - $encoding: encoding name
		#
		# - output_GRAPH filePath ?encoding?;
			#it outputs graph result as ascii art
			# - $filePath: file path of file to output
			# - $encoding: encoding name
##===================================================================
set auto_noexec 1;
package require Tcl 8.6;
#=== <Namespace: dEx> ===
namespace eval ::dEx {
	#****** Variables ******
	# - $TITLE: a title of data set
	# - $FILES: a list of input filenames
	# - $DATA: a list of raw data
	# - $GRAPH: a list of graph parts
	# - $V: an array of counted data; element names in this array are encoded with base64
	variable TITLE {};
	variable FILES {};
	variable DATA {};
	variable GRAPH {};
	variable V;array set V {};
	#****** Procedures ******
	#it resets internal parameters
	proc reset {} {
		foreach x [info vars ::dEx::*] {
			if {[array exists $x]} {
				array unset $x;
			} else {
				set $x {};
			};
		};
	};
	#it sets title as $txt
	proc title {txt} {variable TITLE;set TITLE [join $txt _];};
	#it converts a given data into a list
	proc toList {x {char {}}} {
		# - $x: list or data that is separated by a character
		# - $char: split characters; standard white-space characters is default value
		variable DATA;
		#rEx is regular expression that matches empty strings
		set rEx {^(?:)+$};
		if {[llength $char]} {
			#escaping $x
			set x [string map [list \n $char \f $char] $x];
			foreach e [split $x $char] {
				if {!([regexp $rEx $e])} {lappend DATA $e;};
			};
		} else {
			foreach e [split $x] {
				if {!([regexp $rEx $e])} {lappend DATA $e;};
			};
		};
	};
	#it joins a list with split character
	proc listJoin {x {char \t}} {
		# - $x: a list data
		# - $char: separating characters; tab characters is default value
		set y {};
		set i 0;
		foreach e $x {
			append y [expr {$i>0?$char:{}}] $e;
			incr i 1;
		};
		return $y;
	};
	#it counts elements in given list and returns a list of element names
	proc count {l {numerical 0}} {
		# - $l: a list
		# - $numerical: boolean (0|1) indicates if it regards data as numerical data; 0 is default value
		#$V is counted array
		variable V;
		array unset V;
		#sort is sorting order
		set sort [expr {!!$numerical?{-real}:{-dictionary}}];
		#x64 is base64 encoded text
		set x64 {};
		#== extraction of numerical values ==
		if {!!$numerical} {
			set l_sub {};
			#rgEx is regular expression that matches real number
			set rgEx {^(?:[+-]?[0-9]+(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+(?:\.[0-9]+)?)?)$|^(?:\.[0-9]+)$};
			foreach x $l {
				if {[regexp $rgEx $x]} {lappend l_sub $x;};
			};
			#it overrides $l
			set l $l_sub;
			unset l_sub rgEx;
		};
		foreach x $l {
			#escaping
			if {!$numerical} {
				set x [string map {\| \\\| \/ \\\/ \\ \\\\ \. \\\. \, \\\, \; \\\; \: \\\: \( \\\( \) \\\) \[ \\\[ \] \\\] \{ \\\{ \} \\\} \$ \\\$ \! \\\! \? \\? \< \\\< \> \\\> \# \\\# \% \\\% \- \\\- \+ \\\+ \* \\\* \& \\\& \= \\\=} $x];
			};
			set x64 [binary encode base64 $x];
			if {[llength [array names V $x64]]} {
				incr V($x64) 1;
			} else {
				set V($x64) 1;
			};
		};
		# returned value is a list of element names (not base64 encoded) in a array ($::dEx::V)
		return [lsort $sort [lmap x [array names V] {binary decode base64 $x;}]];
	};
	#it estimates maximum value of a given list
	proc listMax {x} {
		# - $x: a list of numerical values
		set v [lindex $x 0];
		foreach e $x {set v [expr {$v<$e?$e:$v}];};
		return $v;
	};
	#it estimates minimum value of a given list
	proc listMin {x} {
		# - $x: a list of numerical values
		set v [lindex $x 0];
		foreach e $x {set v [expr {$v>$e?$e:$v}];};
		return $v;
	};
	#it outputs data as given filename
	proc output {filePath data {encoding {}}} {
		# - $filePath: file path of file to output
		# - $data: data to output
		# - $encoding: encoding name
		set c [open $filePath w];
		if {[llength $encoding]} {fconfigure $c -encoding $encoding;};
		puts -nonewline $c $data;
		close $c;unset c;
		return $data;
	};
	#it reads data from a file
	proc dRead {filePath {char {}} {encoding {}}} {
		# - $filePath: file path of file to load
		# - $char: split characters; standard white-space characters is default value
		# - $encoding: encoding name
		#$FILES: a list of input filenames
		variable FILES;
		set c [open $filePath r];
		lappend FILES $filePath;
		if {[llength $encoding]} {fconfigure $c -encoding $encoding;};
		if {[llength $char]} {
			::dEx::toList [read -nonewline $c] $char;
		} else {
			::dEx::toList [read -nonewline $c];
		};
		close $c;unset c;
	};
	#it estimates graph width that is not less than 1
	proc width {v {dx 1} {min 0}} {
		# - $v: a positive value
		# - $dx: a number (!$dx<1) that represents a value
		# - $min: a minimum value (!$min<0)
		set v [expr abs($v)];
		set dx [expr {$dx<1?1:$dx}];
		set min [expr {$min<0?0:$min}];
		#w is graph width
		set w [expr {int(ceil(($v-$min)/$dx))}];
		return [expr {!$w<1?$w:$v}];
	};
	#it returns data range list: {min max}
	proc range {elements} {
		# - $elements: a list of element names that is referred wile using counted array ($::dEx::V)
		#min and max are minimum and maximum values of counted array ($::dEx::V)
		set min [::dEx::listMin [lmap e $elements {list $::dEx::V([binary encode base64 $e]);}]];
		set max [::dEx::listMax [lmap e $elements {list $::dEx::V([binary encode base64 $e]);}]];
		#returned value is a list: {$min $max}
		return [list $min $max];
	};
	#it makes a graph as ascii art
	proc graph {elements {dx 1} {min 0} {char \#}} {
		#a block is a unit for dealing with data frequency
		# - $elements: a list of element names that is referred wile using counted array ($::dEx::V)
		# - $dx: a number (!$dx<1) that represents a value which is equivalent to a block in a graph; 1 is default value
		# - $min: the least value (!$min<0) to show in a graph; 0 is default value
		# - $char: a character that is used as a block in a graph; "\#" is default value
		#$TITLE, $V, $FILES and $GRAPH are title of data set, counted array, a list of input filenames and a list of graph parts
		variable TITLE;variable V;variable FILES;variable GRAPH;
		#rg is a list of data range
		set rg [::dEx::range $elements];
		#arMn and arMx are minimum and maximum values of counted array ($::dEx::V)
		set arMn [lindex $rg 0];
		set arMx [lindex $rg 1];
		#nmMx is maximum length of element names in counted array ($::dEx::V)
		set nmMx [::dEx::listMax [lmap e $elements {string length $e;}]];
		#gW is graph width
		set gW [::dEx::width $arMx $dx $min];
		#setting timestamp as graph title when $TITLE has no title 
		set TITLE [expr {[llength $TITLE]?$TITLE:[join [clock format [clock seconds] -gmt 1] _]}];
		#escaping title
		set TITLE [join $TITLE _];
		#making graph
		set GRAPH {};
		lappend GRAPH "\<$TITLE\>";
		lappend GRAPH "Min:${min}_Max:${arMx}_by_dx:$dx";
		lappend GRAPH "[string repeat _ $nmMx]\|[string repeat \+ $gW]";
		foreach x $elements {
			set L {};
			append L "$x[string repeat _ [expr {$nmMx-[string length $x]}]]\|";
			append L "[string repeat $char [::dEx::width $::dEx::V([binary encode base64 $x]) $dx $min]]";
			lappend GRAPH $L;
		};
		lappend GRAPH [string repeat \- [expr {$nmMx+$gW+1}]];
		lappend GRAPH "[llength $FILES] sources:\n$FILES";
		lappend GRAPH [string repeat \= [expr {$nmMx+$gW+1}]];
		return [join $GRAPH \n];
	};
	#it outputs raw data list
	proc output_DATA {filePath {char \t} {encoding {}}} {
		# - $filePath: file path of file to output
		# - $char: separating characters; tab character is default value
		# - $encoding: encoding name
		#$DATA is a list of raw data
		variable DATA;
		if {[llength $DATA]} {
			set d [::dEx::listJoin $DATA $char];
			::dEx::output $filePath $d $encoding;
		} else {
			::dEx::output $filePath {NO DATA} $encoding;
		};
	};
	#it outputs filename list
	proc output_FILES {filePath {char \t} {encoding {}}} {
		# - $filePath: file path of file to output
		# - $char: separating characters; tab character is default value
		# - $encoding: encoding name
		#$FILES is a list of input filenames
		variable FILES;
		if {[llength $FILES]} {
			set d [::dEx::listJoin $FILES $char];
			::dEx::output $filePath $d $encoding;
		} else {
			::dEx::output $filePath {NO DATA} $encoding;
		};
	};
	#it outputs elements list in a counted array
	proc output_elements {filePath {char \t} {encoding {}}} {
		# - $filePath: file path of file to output
		# - $char: separating characters; tab character is default value
		# - $encoding: encoding name
		#$V is counted array
		variable V;
		#E is elements list
		set E [lmap e [array names V] {binary decode base64 $e;}];
		if {[llength $E]} {
			set d [::dEx::listJoin $E $char];
			::dEx::output $filePath $d $encoding;
		} else {
			::dEx::output $filePath {NO DATA} $encoding;
		};
	};
	#it outputs a graph table
	proc output_table {filePath {char \t} {encoding {}}} {
		# - $filePath: file path of file to output
		# - $char: separating characters; tab character is default value
		# - $encoding: encoding name
		#$V is counted array
		variable V;
		#E and tbl are elements list and table parts list
		set E [array names V];
		set tbl {};
		if {[llength $E]} {
			foreach e $E {
				lappend tbl [::dEx::listJoin [list [binary decode base64 $e] $::dEx::V($e)] $char];
			};
			::dEx::output $filePath [::dEx::listJoin $tbl \n] $encoding;
		} else {
			::dEx::output $filePath {NO DATA} $encoding;
		};
	};
	#it outputs graph result as ascii art
	proc output_GRAPH {filePath {encoding {}}} {
		# - $filePath: file path of file to output
		# - $encoding: encoding name
		#$GRAPH is a list of graph parts
		variable GRAPH;
		if {[llength $GRAPH]} {
			::dEx::output $filePath [join $GRAPH \n] $encoding;
		} else {
			::dEx::output $filePath {NO DATA} $encoding;
		};
	};
	#it outputs log of the current values as tcl script
	proc log {filePath {encoding {}}} {
		# - $filePath: file path of file to output
		# - $encoding: encoding name
		#Log is log data
		set Log "if \{\[namespace exists ::dEx\]\} \{";
		foreach x [info vars ::dEx::*] {
			if {[array exists $x]} {
				#arrays
				foreach y [array names $x] {
					append Log "set $x\($y\) [subst $${x}($y)]\;";
				};
			} else {
				#variables
				append Log "set $x \{[subst $$x]\}\;";
			};
		};
		append Log "\}\;";
		::dEx::output $filePath $Log $encoding;
	};
};
