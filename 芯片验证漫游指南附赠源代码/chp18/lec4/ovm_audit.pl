#!/usr/bin/perl -w
# ==============================================================================
# @file   ovm_audit.pl
# @brief  audit OVM code to validate if it is prepared for migration to UVM
# @author Mark Litterick (Verilab)
# ==============================================================================
# This perl script audits OVM code to validate if it is prepared for migration 
# to UVM. No code changes are made by this script, just potential hazards identified. 
# ==============================================================================

use strict;       # Follow rigid variable/subroutine declarations
use warnings;     # Enable all warnings
use Getopt::Long; # Command-line options decoder with long options

my $Pgm = $0;
my $Usage = <<EOF;

Usage: $Pgm

Purpose:
  audit an OVM file or set of files to identify hazards related to:
  - deprecated OVM code
  - non-recommended OVM code
  - deprecated UVM code that can be removed in OVM
  
Options:
  -h(elp)     : print this message
  -v(erbose)  : print information about what constructs are being audited
  -d(ebug)    : print information about what files are being audited
  
Examples:
  audit one file:
    % ovm_audit.pl -v file.sv
  audit a set of files:
    % ovm_audit.pl -v *.sv*
  audit a whole tree of files:
    % find . -name "*.sv*" | xargs -r ovm_audit.pl -v

EOF

# ------------------------------------------------------------------------------
# check one or more files supplied
# ------------------------------------------------------------------------------
if ( @ARGV == 0 ) {
  die "$Pgm: $Usage";
}

# ------------------------------------------------------------------------------
# get options
# ------------------------------------------------------------------------------
our ($ShowHelp, $Verbose, $Debug);

GetOptions( 'help|h'     => \$ShowHelp
          , 'verbose|v'  => \$Verbose
          , 'debug|d'    => \$Debug
          ) or die "$Pgm: $Usage";
          
# ------------------------------------------------------------------------------
# main program - process all files for each category using subroutines
# ------------------------------------------------------------------------------
if ($ShowHelp) { 
  print STDERR $Usage; 
} else {
  if ($Debug) {
    print "\nARGV contains files '@ARGV'\n";
  }
  &ovm_deprecated;
  &ovm_nonrecommended;
  &uvm_deprecated;
  print "\n";
}

# ------------------------------------------------------------------------------
# check for deprecated features based on "deprecated.txt" shipped with OVM
# ------------------------------------------------------------------------------
sub ovm_deprecated {
  print "\nDeprecated OVM constructs:\n";
  # Deprecated Features 
  # Global Variables
  if ($Verbose) { print "- ovm_test_top          \n"; }  system("grep -n ovm_test_top           @ARGV");
  if ($Verbose) { print "- ovm_top_levels        \n"; }  system("grep -n ovm_top_levels         @ARGV");
  if ($Verbose) { print "- ovm_phase_func        \n"; }  system("grep -n ovm_phase_func         @ARGV");
  if ($Verbose) { print "- post_new_ph           \n"; }  system("grep -n post_new_ph            @ARGV");
  if ($Verbose) { print "- export_connections_ph \n"; }  system("grep -n export_connections_ph  @ARGV");
  if ($Verbose) { print "- import_connections_ph \n"; }  system("grep -n import_connections_ph  @ARGV");
  if ($Verbose) { print "- configure_ph          \n"; }  system("grep -n configure_ph           @ARGV");
  if ($Verbose) { print "- pre_run_ph            \n"; }  system("grep -n pre_run_ph             @ARGV");
  # Global Functions
  if ($Verbose) { print "- ovm_find_component    \n"; }  system("grep -n ovm_find_component     @ARGV");
  if ($Verbose) { print "- ovm_print_topology    \n"; }  system("grep -n ovm_print_topology     @ARGV");
  if ($Verbose) { print "- avm_                  \n"; }  system("grep -n avm_                   @ARGV");
  if ($Verbose) { print "- global_reporter       \n"; }  system("grep -n global_reporter        @ARGV");
  # Classes
  if ($Verbose) { print "- ovm_threaded_component\n"; }  system("grep -n ovm_threaded_component @ARGV");
  # Methods
  if ($Verbose) { print "- do_sprint             \n"; }  system("grep -n do_sprint              @ARGV");
  if ($Verbose) { print "- print_unit            \n"; }  system("grep -n print_unit             @ARGV");
  if ($Verbose) { print "- do_test               \n"; }  system("grep -n 'do_test '             @ARGV");
  if ($Verbose) { print "- m_do_test_mode        \n"; }  system("grep -n m_do_test_mode         @ARGV");
  if ($Verbose) { print "- do_task_phase         \n"; }  system("grep -n do_task_phase          @ARGV");
  # (cant object to env::run)
  if ($Verbose) { print "- set_parent_seq        \n"; }  system("grep -n set_parent_seq         @ARGV");
  if ($Verbose) { print "- get_parent_seq        \n"; }  system("grep -n get_parent_seq         @ARGV");
  if ($Verbose) { print "- pre_do                \n"; }  system("grep -n pre_do                 @ARGV | grep '_item.sv'");
  if ($Verbose) { print "- body                  \n"; }  system("grep -n body                   @ARGV | grep '_item.sv'");
  if ($Verbose) { print "- mid_do                \n"; }  system("grep -n mid_do                 @ARGV | grep '_item.sv'");
  if ($Verbose) { print "- post_do               \n"; }  system("grep -n post_do                @ARGV | grep '_item.sv'");
  if ($Verbose) { print "- wait_for_grant        \n"; }  system("grep -n wait_for_grant         @ARGV | grep '_item.sv'");
  if ($Verbose) { print "- send_request          \n"; }  system("grep -n send_request           @ARGV | grep '_item.sv'");
  if ($Verbose) { print "- wait_for_item_done    \n"; }  system("grep -n wait_for_item_done     @ARGV | grep '_item.sv'");
  if ($Verbose) { print "- start_sequence        \n"; }  system("grep -n start_sequence         @ARGV");
  # Macros
  if ($Verbose) { print "- OVM_REPORT_           \n"; }  system("grep -n OVM_REPORT_            @ARGV");
  # Removed Features
  # Classes
  if ($Verbose) { print "- ovm_seq_prod_if       \n"; }  system("grep -n ovm_seq_prod_if        @ARGV");
  if ($Verbose) { print "- ovm_seq_cons_if       \n"; }  system("grep -n ovm_seq_cons_if        @ARGV");
  if ($Verbose) { print "- ovm_seq_item_prod_if  \n"; }  system("grep -n ovm_seq_item_prod_if   @ARGV");
  if ($Verbose) { print "- ovm_seq_item_cons_if  \n"; }  system("grep -n ovm_seq_item_cons_if   @ARGV");
  if ($Verbose) { print "- ovm_virtual_sequencer \n"; }  system("grep -n ovm_virtual_sequencer  @ARGV");
  if ($Verbose) { print "- ovm_scenario          \n"; }  system("grep -n ovm_scenario           @ARGV");
  # Methods
  if ($Verbose) { print "- check_connection_size \n"; }  system("grep -n check_connection_size  @ARGV");
  if ($Verbose) { print "- do_display            \n"; }  system("grep -n do_display             @ARGV");
  if ($Verbose) { print "- absolute_lookup       \n"; }  system("grep -n absolute_lookup        @ARGV");
  if ($Verbose) { print "- relative_lookup       \n"; }  system("grep -n relative_lookup        @ARGV");
  if ($Verbose) { print "- find_component        \n"; }  system("grep -n find_component         @ARGV");
  if ($Verbose) { print "- get_num_components    \n"; }  system("grep -n get_num_components     @ARGV");
  if ($Verbose) { print "- get_component         \n"; }  system("grep -n get_component          @ARGV");
  if ($Verbose) { print "- do_set_env            \n"; }  system("grep -n do_set_env             @ARGV");
  if ($Verbose) { print "- m_env                 \n"; }  system("grep -n ' m_env'               @ARGV");
  if ($Verbose) { print "- add_to_debug_list     \n"; }  system("grep -n add_to_debug_list      @ARGV");
  if ($Verbose) { print "- build_debug_lists     \n"; }  system("grep -n build_debug_lists      @ARGV");
  if ($Verbose) { print "- m_components          \n"; }  system("grep -n m_components           @ARGV");
  if ($Verbose) { print "- m_ports               \n"; }  system("grep -n m_ports                @ARGV");
  if ($Verbose) { print "- m_exports             \n"; }  system("grep -n m_exports              @ARGV");
  if ($Verbose) { print "- m_implementations     \n"; }  system("grep -n m_implementations      @ARGV");
  if ($Verbose) { print "- ovm_report_message    \n"; }  system("grep -n ovm_report_message     @ARGV");
  if ($Verbose) { print "- report_message_hook   \n"; }  system("grep -n report_message_hook    @ARGV");
}

# ------------------------------------------------------------------------------
# check for non-recommended OVM 
# ------------------------------------------------------------------------------
sub ovm_nonrecommended {
  print "\nNon-recommended OVM constructs:\n";
  if ($Verbose) { print "- stop()                \n"; }  system("grep -n ' stop()'           @ARGV");
  if ($Verbose) { print "- global_stop_request   \n"; }  system("grep -n global_stop_request @ARGV");
  if ($Verbose) { print "- ovm_report_info       \n"; }  system("grep -n ovm_report_info     @ARGV");
  if ($Verbose) { print "- ovm_report_warning    \n"; }  system("grep -n ovm_report_warning  @ARGV");
  if ($Verbose) { print "- ovm_report_error      \n"; }  system("grep -n ovm_report_error    @ARGV");
  if ($Verbose) { print "- ovm_report_fatal      \n"; }  system("grep -n ovm_report_fatal    @ARGV");
}

# ------------------------------------------------------------------------------
# check for deprecated UVM that can be removed in OVM to prepare for migration
# ------------------------------------------------------------------------------
sub uvm_deprecated {
  print "\nDeprecated UVM constructs (OVM constructs that are deprecated in UVM):\n";
  # The OVM sequence library macros:
  if ($Verbose) { print "- ovm_sequencer_utils       \n"; }  system("grep -n ovm_sequencer_utils       @ARGV");
  if ($Verbose) { print "- ovm_sequencer_param_utils \n"; }  system("grep -n ovm_sequencer_param_utils @ARGV");
  if ($Verbose) { print "- ovm_sequence_utils        \n"; }  system("grep -n ovm_sequence_utils        @ARGV");
  if ($Verbose) { print "- ovm_declare_sequence_lib  \n"; }  system("grep -n ovm_declare_sequence_lib  @ARGV");
  if ($Verbose) { print "- ovm_update_sequence_lib   \n"; }  system("grep -n ovm_update_sequence_lib   @ARGV");
  if ($Verbose) { print "- ovm_sequence_lib_and_item \n"; }  system("grep -n ovm_sequence_lib_and_item @ARGV");
  # The OVM builtin sequences:
  if ($Verbose) { print "- ovm_random_sequence       \n"; }  system("grep -n ovm_random_sequence       @ARGV");
  if ($Verbose) { print "- ovm_exhaustive_sequence   \n"; }  system("grep -n ovm_exhaustive_sequence   @ARGV");
  if ($Verbose) { print "- ovm_simple_sequence       \n"; }  system("grep -n ovm_simple_sequence       @ARGV");
  # The OVM sequence-library-supporting sequence API:
  if ($Verbose) { print "- seq_kind                  \n"; }  system("grep -n seq_kind                  @ARGV");
  if ($Verbose) { print "- num_sequences             \n"; }  system("grep -n num_sequences             @ARGV");
  if ($Verbose) { print "- get_seq_kind              \n"; }  system("grep -n get_seq_kind              @ARGV");
  if ($Verbose) { print "- get_sequence              \n"; }  system("grep -n get_sequence              @ARGV");
  if ($Verbose) { print "- do_sequence_kind          \n"; }  system("grep -n do_sequence_kind          @ARGV");
  if ($Verbose) { print "- get_sequence_by_name      \n"; }  system("grep -n get_sequence_by_name      @ARGV");
  # The entire OVM sequencer 'count' and 'default_sequence' config mechanism:
  if ($Verbose) { print "- count                     \n"; }  system("grep -n count                     @ARGV | grep _config_");
  if ($Verbose) { print "- max_random_count          \n"; }  system("grep -n max_random_count          @ARGV");
  if ($Verbose) { print "- max_random_depth          \n"; }  system("grep -n max_random_depth          @ARGV");
  if ($Verbose) { print "- default_sequence          \n"; }  system("grep -n default_sequence          @ARGV");
}
