

program tb;

virtual class animal;
  function new(int age_i);
    age = age_i;
  endfunction

  pure virtual function void make_sound();
  int age=-1;
endclass

class lion extends animal;
  string name=" ";
  function new(int age_i,string name_i);
    super.new(age_i);
    name=name_i;
  endfunction

  virtual function void make_sound();
    $display("this is lion!!!");
  endfunction
endclass

class chicken extends animal;
  string name=" ";
  function new(int age_i,string name_i);
    super.new(age_i);
    name=name_i;
  endfunction

  virtual function void make_sound();
    $display("this is chicken!!!");
  endfunction
endclass

class animal_cage #(type T);
  static T cage[$];
  static function void cage_animal(T aml);
    $display("add %s to cage!!!",aml.name);
    cage.push_back(aml);
  endfunction

  static function T list_animal();
    $display("list animal starting !!!");
    foreach(cage[i]) begin
      $display("animal name is %s",cage[i].name);
    end
    $display("list animal ending !!!");
  endfunction
endclass

initial begin
  lion lion0;
  chicken ck0;
  lion0 = new("10","luis");
  animal_cage#(lion)::cage_animal(lion0);
  lion0 = new("20","alis");
  animal_cage#(lion)::cage_animal(lion0);


  ck0 = new("100","bob");
  animal_cage#(chicken)::cage_animal(ck0);
  ck0 = new("200","john");
  animal_cage#(chicken)::cage_animal(ck0);

  animal_cage#(lion)::list_animal();
  animal_cage#(chicken)::list_animal();
end


endprogram


