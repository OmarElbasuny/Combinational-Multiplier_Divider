------------------ Libraries
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.math_real.ALL;

entity div is
   generic (
           N: integer := 8
         );
    port (
       a   : in  signed(N-1 downto 0);
       b   : in  signed(N-1 downto 0);
		 
       m   : out signed(N-1 downto 0);
       r   : out signed(N-1 downto 0); 
       error: out std_logic;
		 busy : out std_logic;
       valid : out std_logic
      
        ); 
end div;

architecture Behavioral of div is
  
 begin
 
  p_div: process ( a , b ) is
     variable  r_reg,restore:signed (N-1 downto 0)  ; 
     variable  ra_reg :signed (2*N-1 downto 0) ;   
     variable   a_reg :signed (N-1 downto 0) ;
     variable   b_reg :signed  ( N-1 downto 0) ;
     variable   m_s :signed (N-1 downto 0) ;
     variable  zeros : signed (N-1 downto 0 ); 
    begin      
     ---------------------- unsigned for input a
     zeros := ( others => '0');
      if a (N-1)='1' then    
   for i in 0 to N-1 loop
      a_reg(i):= ( a(i) xor '1');
    end loop;
        a_reg :=a_reg+1;
     else
       a_reg :=a;
      end if; 
     -------------------------end for unsigned
      ---------------------- unsigned for input b
     
      if  b(N-1) = '1' then    
      for i in 0 to N-1 loop
        b_reg(i) :=( b(i) xor '1') ; 
        end loop;
          b_reg :=b_reg+1;
      else
         b_reg :=b;
    end if; 
     --------------------------end for unsigned b
    
      r_reg      :=(others => '0');
      ra_reg     := r_reg & a_reg;
      
	
    
					  -- Error detection
				if  b_reg  = zeros then
						error<= '1'; -- Division by zero error
						valid <= '0';
						
			  elsif a_reg >= b_reg then --------------------- for tesst if a> B or not
						  error<= '0';
							valid <= '1';
					for i in 0 to N-1 loop
						  ra_reg   := ra_reg (2*N-2 downto 0) &'0';----shift left one bit   ---- -1
						  restore  := ra_reg ( 2*N-1 downto N) ;                             ----1
						  r_reg    := restore - ( b_reg);
						  ra_reg   := r_reg  & ra_reg(N-1 downto 0);
					  -------------- msb
					  if  r_reg(N-1) = '1' then
					 
					   	a_reg := ra_reg(N-1 downto 1) &'0';
						   ra_reg  :=restore & a_reg ;			  
					  else  
						  a_reg:=  ra_reg(N-1 downto 1) &'1';
						  ra_reg := r_reg  &  a_reg;
						
					   end if;--------end msb   
					  end loop;
						  
						  r_reg := (ra_reg (2*N-1 downto N));  
						  m_s := (ra_reg (N-1 downto 0));
					 
					-----------------signed for result quotient
					 
					 
					  if (a(N-1) xor b(N-1))='1' then
						 
						 for i in 0 to N-1 loop
							 m_s(i) := m_s (i) xor '1';
						 end loop;
						    m<= m_s +1 ;
					  
					  else			 
										 m<= m_s ;       
						end if;
					 ---------signed
					 -----------------signed for result reminder
					 
					 
					  if (a(N-1) xor b(N-1)) ='1' then
						 
						  for i in 0 to N-1 loop
					 
							  r_reg(i) := r_reg (i) xor '1';
					  
						   end loop;
							r <= r_reg + 1;  
					 
				       else
									r <=  r_reg;       
					  end if;
					 ---------end unsigned
					 
					else  ----- b>a
						 error <= '0';
						  valid <= '1';
							  r<=a;
								m<= (others => '0');
					 end if;
							
  end process;      
end Behavioral;
