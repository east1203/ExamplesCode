/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
class testbench;

   virtual tinyalu_bfm bfm;

   tester    tester_h;
   coverage  coverage_h;
   scoreboard scoreboard_h;
   
   function new (virtual tinyalu_bfm b);
       bfm = b;
   endfunction : new

   task execute();
   $display("@ %0t : [testbench] testbench is executed beginning !!! ",$time);
      tester_h    = new(bfm);
      coverage_h   = new(bfm);
      scoreboard_h = new(bfm);

      fork
         tester_h.execute();
         coverage_h.execute();
         scoreboard_h.execute();
      join_none
$display("@ %0t : [testbench] testbench is executed ending !!! ",$time);
   endtask : execute
endclass : testbench

     
   
