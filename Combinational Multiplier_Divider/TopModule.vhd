LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.math_real.ALL;

 entity mulDiv_comb  is
       generic(
               N : positive := 8  -- Number of bits for A and B
          );

     port(
        A : in signed(n-1 downto 0); --multiplicand 
        B : in signed(n-1 downto 0); -- multiplier
		  mode :in  std_logic;          ---0 for multiplication , 1 for division
	     M : out signed(n-1 downto 0);
        R : out signed(n-1 downto 0);
		   
		  error: out std_logic;
		  busy : out std_logic;
        valid : out std_logic; 
      total_mul : out signed(2*n-1 downto 0)  

        );
     
     end mulDiv_comb ;
	  
	  
	  ARCHITECTURE behavior OF mulDiv_comb  IS 
	     
 -----------component of divider
		  
	component div is  
         generic (
           N: integer := 8);
				 port (
					 a   : in  signed(N-1 downto 0);
					 b   : in  signed(N-1 downto 0);
				
					 m   : out signed(N-1 downto 0);
					 r   : out signed(N-1 downto 0); --- -1
					 error: out std_logic;
					 busy : out std_logic;
					 valid : out std_logic
                              
        ); 
 end component div;
		  
	  ----------omponent of mul
    		  
	component mul is  
         generic (
           N: integer := 8);
				 port (
					 a   : in  signed(N-1 downto 0);
					 b   : in  signed(N-1 downto 0);
					 m   : out signed(N-1 downto 0);
					 r   : out signed(N-1 downto 0);
                                  total_mul : out signed(2*n-1 downto 0)
					 
      
        ); 
 end component mul;
 
 ------------------------signals
  signal m_d :   signed (N-1 downto 0) ;
  signal  m_m :   signed (N-1 downto 0) ;

 signal r_d :   signed (N-1 downto 0) ;
 signal r_m :   signed (N-1 downto 0) ;
 signal error_m :std_logic;
 signal error_d : std_logic;

 signal valid_m :std_logic;
 signal valid_d: std_logic;
 
 signal busy_m : std_logic;
 signal busy_d :std_logic;
 
 begin 
 div_u :div  
      generic map (N)
		
		PORT MAP
       ( 
        
        a =>a,
        b =>b,
		  m => m_d,
		  r => r_d ,
		  error => error_d  ,
		 valid => valid_d,
		  busy => busy_d
     
     );
 
  mul_u :mul  
      generic map (N)
		
		PORT MAP
       ( 
       
        a => a,
        b =>b,
        m => m_m,
        r => r_m ,
      total_mul =>total_mul
     
     );
	  
	   m <= m_m when mode = '0' else m_d;
		r <= r_m when mode = '0' else r_d;
		busy <=busy_m  when mode = '0' else busy_d;
		valid <=valid_m when mode = '0' else valid_d;
		error <= error_m when mode = '0' else error_d;

 END behavior;
 
 
 
