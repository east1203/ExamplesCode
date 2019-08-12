module lucky_draw;

localparam P_TEAMS = 20;
localparam P_TIMES = 20;

int team_num;
int selected_team_nums[int];
bit success;
int times = 0;

initial begin
  for(int i=0; i<P_TIMES; i++) begin
    success = std::randomize(team_num) with {team_num>0; team_num <= P_TEAMS; selected_team_nums.exists(team_num) == 0;};
    if(success) begin
      times++;
      selected_team_nums[team_num] = team_num;
      $display("@%d :: team number is %d ", times, team_num);
    end
  end
end


endmodule: lucky_draw
