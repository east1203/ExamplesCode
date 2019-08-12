

class fmt_rsp_trans;
  bit [ 1:0] id;
  bit [31:0] data_q[$];
  int        length;

  function bit compare(fmt_rsp_trans t);
    if(id != t.id 
      || length != t.length
      || data_q.size() != t.data_q.size())
      return 0;
    foreach(data_q[i]) begin
      if(data_q[i] != t.data_q[i])
        return 0;
    end
    return 1;
  endfunction
endclass
