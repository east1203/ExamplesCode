
class coverage;

virtual tinyalu_bfm bfm;
   
   
   byte         unsigned        A;
   byte         unsigned        B;
   operation_t  op_set;


   covergroup op_cov;
      coverpoint op_set {
        bins single_cyls[] = {[add_op:xor_op],no_op,rst_op};
        bins mul_cyls = {mul_op};

        bins op2rst[] = ([no_op:mul_op] => rst_op);
        bins rst2op[] = (rst_op => [no_op:mul_op]);
        
        bins sngl_mul[] = ([add_op:xor_op],no_op => mul_op);
        bins mul_sngl[] = (mul_op => [add_op:xor_op], no_op);
        
        bins doubleop [] = ([add_op:mul_op][*2]);
        bins mulop[] = (mul_op[*3:5]);
      
      }
   endgroup


   covergroup zeros_or_ones_on_ops;
      all_ops:  coverpoint op_set {
             ignore_bins ig = {no_op,rst_op};
             }
      a_leg: coverpoint A{
             bins ones = {8'hff};
             bins others={[8'h01:8'hfe]};
             bins zeros = {8'h00};
             }
      b_leg: coverpoint B{
             bins ones = {8'hff};
             bins others={[8'h01:8'hfe]};
             bins zeros = {8'h00};
             }
      op_00_FF:cross all_ops,a_leg,b_leg {
       bins add_00 = binsof (all_ops) intersect {add_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros)); 
      
        bins add_FF = binsof (all_ops) intersect {add_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins and_00 = binsof (all_ops) intersect {and_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins and_FF = binsof (all_ops) intersect {and_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins xor_00 = binsof (all_ops) intersect {xor_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins xor_FF = binsof (all_ops) intersect {xor_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_00 = binsof (all_ops) intersect {mul_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins mul_FF = binsof (all_ops) intersect {mul_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_max = binsof (all_ops) intersect {mul_op} &&
                        (binsof (a_leg.ones) && binsof (b_leg.ones));
         ignore_bins other = binsof(a_leg.others) && binsof(b_leg.others);
      }
   endgroup


   function new (virtual tinyalu_bfm b);
     op_cov = new();
     zeros_or_ones_on_ops = new();
     bfm = b;
   endfunction : new
    
   task execute();
     forever begin
        @(negedge bfm.clk);
        A = bfm.A;
        B = bfm.B;
        op_set = bfm.op_set;
        op_cov.sample();
        zeros_or_ones_on_ops.sample();
     end

   endtask


endclass
