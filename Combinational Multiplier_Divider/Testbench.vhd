LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.math_real.ALL;
USE std.textio.ALL;
--USE work.my_types.ALL;

entity TESTBENCH is
end entity;

architecture comb_tb of TESTBENCH  is 

component mulDiv_comb IS
     GENERIC(
               N : POSITIVE := 8 
             );
     port(
       A   :    in signed(n-1 downto 0);   --multiplicand 
       B    :    in signed(n-1 downto 0);  -- multiplier
       MODE  :    in  std_logic;            ---0 for multiplication , 1 for division
       M      :    out signed(n-1 downto 0);
       R       :    out signed(n-1 downto 0);	   
       BUSY     :    out std_logic;
       ERROR     :    out std_logic;
       VALID      :    out std_logic;
       total_mul : out signed(2*n-1 downto 0)
                     
        );
end component mulDiv_comb;

constant N : INTEGER := 8;
SIGNAL A_tb : signed(n-1 downto 0);
SIGNAL B_tb: signed(n-1 downto 0);
SIGNAL m : signed (N - 1 DOWNTO 0);
SIGNAL r : signed (N - 1 DOWNTO 0);
SIGNAL  MODE_tb: STD_LOGIC;
SIGNAL ERROR_tb: STD_LOGIC;
SIGNAL VALID_tb: STD_LOGIC;
SIGNAL BUSY_tb : STD_LOGIC;
signal total_mul :  signed(2*n-1 downto 0);

begin





DUT: mulDiv_comb
   GENERIC MAP(
             N => n
               )
   PORT MAP    (
                     
               A =>A_tb,
               B=>B_tb,
              MODE=>MODE_tb,
               M=>M,
               R =>R,
              BUSY =>BUSY_TB,
              ERROR=>ERROR_TB,
              VALID=>VALID_tb,
              total_mul =>total_mul
                );
p1: PROCESS 

   

FILE testcases: text OPEN READ_MODE IS "cases.txt";
FILE Output_File : text OPEN WRITE_MODE IS "comb_log.txt";

    VARIABLE test_case_line     : LINE;
    VARIABLE line_out    : LINE;
    VARIABLE in_1_in_file, in_2_in_file : std_logic_vector(n-1 downto 0);  
    VARIABLE mode_in_file     : STD_LOGIC;
    VARIABLE m_in_file    : std_logic_vector (n-1 DOWNTO 0);
    VARIABLE r_in_file    :std_logic_vector (n-1 DOWNTO 0);
    
    

PROCEDURE COMB IS 
   BEGIN
   WHILE not endfile(testcases)loop
readline(testcases,test_case_line);
read(test_case_line,mode_in_file);
read(test_case_line,in_1_in_file);
read(test_case_line,in_2_in_file);
read(test_case_line,m_in_file );
read(test_case_line,r_in_file);

A_TB    <=  signed(in_1_in_file);
B_TB    <=  signed(in_2_in_file);
MODE_TB <=  mode_in_file;

WAIT FOR 30 ns;

write(line_out,string'("time is now : "));
write(line_out,now);
write(line_out,string'(" A : "));
write(line_out,in_1_in_file);
write(line_out,string'(" B : "));
write(line_out,in_2_in_file);
write(line_out,string'(" expected M  :  "));
write(line_out,m_in_file);
write(line_out,string'(" expected R :  "));
write(line_out,r_in_file);


IF (MODE_TB = '0') THEN
if((m = signed(m_in_file)) AND (r = signed(r_in_file))) then
write(line_out,string'(" [MULT. CASE PASSED]"));

else
write(line_out,string'(" [MULT. CASE FAILED]"));

end if;

else 
if((m = signed(m_in_file)) AND (r = signed(r_in_file))) then
write(line_out,string'(" [DIV. CASE PASSED]"));

else 
write(line_out,string'(" [DIV. CASE FAILED]"));

end if ;
end if;
writeline(Output_File,line_out);

end loop;
end procedure COMB;

begin

comb;

wait;

end process;
end architecture comb_tb;