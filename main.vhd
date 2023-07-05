library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    type state_type is(S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13); 

    signal curr_state, next_state: state_type; 
    
    signal max, min, max_next, min_next : std_logic_vector (7 downto 0) := "00000000";
    
    signal nCol, nRow, nCol_next, nRow_next : std_logic_vector (7 downto 0) := "00000000";

    signal dim, counter, dim_next, counter_next : std_logic_vector(15 downto 0) := "0000000000000000";
    
    signal delta_value, delta_value_next : std_logic_vector (7 downto 0) := "00000000";
    
    signal ready, ready_next : std_logic := '0';
    
    signal current_pixel, current_pixel_next : std_logic_vector (7 downto 0) := "XXXXXXXX";
    
    signal shift_level, shift_level_next: std_ulogic_vector (3 downto 0) := "XXXX";
    
    signal temp_pixel, temp_pixel_next : std_logic_vector (15 downto 0) := "XXXXXXXXXXXXXXXX";
    
    signal new_pixel_value, new_pixel_value_next : std_logic_vector (7 downto 0) := "XXXXXXXX";
    
begin


    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            curr_state <= S0;
            max <= "00000000";
            min <= "11111111";
            ready <= '0';
            current_pixel <= "XXXXXXXX";
            counter <= "0000000000000000";
            delta_value <= "00000000";
            temp_pixel <= "XXXXXXXXXXXXXXXX";
            dim <= "0000000000000000";
            new_pixel_value <= "XXXXXXXX";
            nRow <= "XXXXXXXX";
            nCol <= "XXXXXXXX";
            shift_level <= "XXXX";
            
        elsif rising_edge(i_clk) then 
                
            curr_state <= next_state;
            new_pixel_value <= new_pixel_value_next;
            temp_pixel <= temp_pixel_next;
            counter <= counter_next;
            dim <= dim_next;
            ready <= ready_next;
            current_pixel <= current_pixel_next;
            max <= max_next;
            min <= min_next;
            delta_value <= delta_value_next;
            nRow <= nRow_next;
            nCol <= nCol_next;
            shift_level <= shift_level_next;
        
        end if;
    end process;
    
    
    
    process(curr_state, i_start, ready, counter, dim)
        begin
            next_state <= curr_state;
         case curr_state is
                when S0 =>
                   if i_start = '1' then
                      next_state <= S1;
                  end if;
                when S1 =>
                    next_state <= S2;
                when S2 =>
                    next_state <= S3;
                when S3 =>
                    next_state <= S4;
                when S4 =>
                    next_state <= S5;
                when S5 =>
                    next_state <= S6;
                when S6 =>
                    if(ready = '0') then
                        next_state <= S7;
                    elsif(ready = '1') then
                        next_state <= S10;
                    end if;
                when S7 =>
                    if( unsigned(counter) < unsigned(dim)+2 ) then
                        next_state <= S5;
                    else
                        next_state <= S8;
                    end if;
                when S8 =>
                    next_state <= S9;
                when S9 =>
                    next_state <= S5;
                when S10 =>
                    next_state <= S11;
                when S11 =>
                    next_state <= S12;
                when S12 =>
                    if(counter < (dim+2)) then
                        next_state <= S5;
                    else
                        next_state <= S13;
                    end if;
                when S13 =>
                    if(i_start = '0') then
                        next_state <= S0;
                    end if;                       
          end case;
     end process;   
    
    process(curr_state, i_data, delta_value, shift_level, temp_pixel, new_pixel_value, current_pixel, max, min, counter, dim, ready, nRow, nCol)
        begin
        
        counter_next <= counter;
        dim_next <= dim;
        ready_next <= ready;
        current_pixel_next <= current_pixel;
        max_next <= max;
        min_next <= min;
        delta_value_next <= delta_value;
        temp_pixel_next <= temp_pixel;
        new_pixel_value_next <= new_pixel_value;
        nRow_next <= nRow;
        nCol_next <= nCol;
        shift_level_next <= shift_level;
            
        case curr_state is
            when S0 => 
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                max_next <= "00000000";
                min_next <= "11111111";
            when S1 =>
                o_address <= "0000000000000000";
                o_done <= '0';
                o_en <= '1';
                o_we <= '0';
                o_data <= "XXXXXXXX";
            when S2 =>
                o_address <= "0000000000000001";
                o_done <= '0';
                o_en <= '1';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                nCol_next <= i_data;
            when S3 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";  
                nRow_next <= i_data; 
             when S4 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                dim_next <= nRow * nCol;
                counter_next <= "0000000000000010";
                ready_next <= '0'; 
             when S5 =>  
                o_address <= counter;
                o_done <= '0';
                o_en <= '1';
                o_we <= '0';
                o_data <= "XXXXXXXX"; 
             when S6 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                current_pixel_next <= i_data;
                counter_next <= std_logic_vector(unsigned(counter)+1);       
             when S7 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                if(current_pixel > max) then
                    max_next <= current_pixel;
                end if;
                if(current_pixel < min) then
                    min_next <= current_pixel;
                end if;
             when S8 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                delta_value_next <= max - min;
                counter_next <= "0000000000000010";
                ready_next <= '1';
             when S9 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";           
                if(delta_value = "00000000") then
                    shift_level_next <= "1000";
                elsif(delta_value < "00000011") then
                    shift_level_next <= "0111";
                elsif(delta_value < "00000111") then
                    shift_level_next <= "0110";
                elsif(delta_value < "00001111") then
                    shift_level_next <= "0101";
                elsif(delta_value < "00011111") then
                    shift_level_next <= "0100";
                elsif(delta_value < "00111111") then
                    shift_level_next <= "0011";
                elsif(delta_value < "01111111") then
                    shift_level_next <= "0010";
                elsif(delta_value < "11111111") then
                    shift_level_next <= "0001";
                elsif(delta_value = "11111111") then
                    shift_level_next <= "0000"; 
                end if;
              when S10 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                case shift_level is
                    when "0000" =>
                        temp_pixel_next <= "00000000" & (current_pixel - min);
                    when "0001" =>
                        temp_pixel_next <= "0000000" & (current_pixel - min) & "0";
                    when "0010" =>
                        temp_pixel_next <= "000000" & (current_pixel - min) & "00";
                    when "0011" =>
                        temp_pixel_next <= "00000" & (current_pixel - min) & "000";
                    when "0100" =>
                        temp_pixel_next <= "0000" & (current_pixel - min) & "0000";
                    when "0101" =>
                        temp_pixel_next <= "000" & (current_pixel - min) & "00000";
                    when "0110" =>
                        temp_pixel_next <= "00" & (current_pixel - min) & "000000";
                    when "0111" =>
                        temp_pixel_next <= "0" & (current_pixel - min) & "0000000";
                    when "1000" =>
                        temp_pixel_next <= (current_pixel - min) & "00000000";
                    when others => 
                end case;
              when S11 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";
                if(temp_pixel < "0000000011111111") then
                    new_pixel_value_next <= temp_pixel(7 downto 0);
                else
                    new_pixel_value_next <= "11111111";
                end if;
              when S12 =>
                o_address <= (counter + dim)-1;
                o_done <= '0';
                o_en <= '1';
                o_we <= '1';
                o_data <= new_pixel_value;
              when S13 =>
                o_address <= "XXXXXXXXXXXXXXXX";
                o_done <= '1';
                o_en <= '0';
                o_we <= '0';
                o_data <= "XXXXXXXX";  
        end case;
    end process;

                                
end Behavioral;
