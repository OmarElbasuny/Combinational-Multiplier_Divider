LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.math_real.ALL;
 
    entity mul is
          generic(
               N : positive := 8  -- Number of bits for A and B
                  );
          port(
                b: in signed(n-1 downto 0);
                a: in signed(n-1 downto 0);
                m: out signed(n-1 downto 0);
                r: out signed(n-1 downto 0);
               total_mul : out signed(2*n-1 downto 0)
                 );
    end mul;
   
    architecture mul of mul is
        begin
           
            process(a, b)
             variable tmp_a: signed(2*n downto 0);
             variable sum,product : signed(n-1 downto 0);
             variable i:integer;


                begin
                    tmp_a := ( others => '0');
                    sum := b;
                    tmp_a(n downto 1) := a;
                   
                    for i in 0 to n-1 loop
                       if(tmp_a(1) = '1' and tmp_a(0) = '0') then
                          product := (tmp_a(2*n downto n+1));
                          tmp_a(2*n downto n+1) := (product - sum);
                         
                       elsif(tmp_a(1) = '0' and tmp_a(0) = '1') then
                          product := (tmp_a(2*n downto n+1));
                          tmp_a(2*n downto n+1) := (product + sum);
                         
                       end if;
                      
                       tmp_a(2*n-1 downto 0) := tmp_a(2*n downto 1);
                      
                    end loop;
                   
                    m <= tmp_a(2*n downto n+1);
                    r <= tmp_a(n downto 1);
                    total_mul <= tmp_a(2*n downto 1);
                   
                end process;
               
            end mul;
