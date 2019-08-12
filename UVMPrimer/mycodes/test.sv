module producer(output byte shared, input bit put_it, output bit get_it);
   initial
     repeat(3) begin 
        $display("Sent %0d", ++shared);
        get_it = ~get_it;
        @(put_it);
     end
endmodule : producer

module consumer(input byte shared,  output bit put_it, input bit get_it);
   initial
      forever begin
         @(get_it);
         $display("Received: %0d", shared);
         put_it = ~put_it;
      end
endmodule : consumer

module top; 
   byte shared;
   producer p (shared, put_it, get_it);
   consumer c (shared, put_it, get_it);
endmodule : top
