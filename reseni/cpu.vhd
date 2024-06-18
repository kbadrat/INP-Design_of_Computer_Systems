-- cpu.vhd: Simple 8-bit CPU (BrainLove interpreter)
-- Copyright (C) 2021 Brno University of Technology,
--                    Faculty of Information Technology
-- Author(s): Vladyslav Kovalets, xkoval21
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity cpu is
 port (
   CLK   : in std_logic;  -- hodinovy signal
   RESET : in std_logic;  -- asynchronni reset procesoru
   EN    : in std_logic;  -- povoleni cinnosti procesoru
 
   -- synchronni pamet ROM
   CODE_ADDR : out std_logic_vector(11 downto 0); -- adresa do pameti
   CODE_DATA : in std_logic_vector(7 downto 0);   -- CODE_DATA <- rom[CODE_ADDR] pokud CODE_EN='1'
   CODE_EN   : out std_logic;                     -- povoleni cinnosti
   
   -- synchronni pamet RAM
   DATA_ADDR  : out std_logic_vector(9 downto 0); -- adresa do pameti
   DATA_WDATA : out std_logic_vector(7 downto 0); -- ram[DATA_ADDR] <- DATA_WDATA pokud DATA_EN='1'
   DATA_RDATA : in std_logic_vector(7 downto 0);  -- DATA_RDATA <- ram[DATA_ADDR] pokud DATA_EN='1'
   DATA_WREN  : out std_logic;                    -- cteni z pameti (DATA_WREN='0') / zapis do pameti (DATA_WREN='1')
   DATA_EN    : out std_logic;                    -- povoleni cinnosti
   
   -- vstupni port
   IN_DATA   : in std_logic_vector(7 downto 0);   -- IN_DATA obsahuje stisknuty znak klavesnice pokud IN_VLD='1' a IN_REQ='1'
   IN_VLD    : in std_logic;                      -- data platna pokud IN_VLD='1'
   IN_REQ    : out std_logic;                     -- pozadavek na vstup dat z klavesnice
   
   -- vystupni port
   OUT_DATA : out  std_logic_vector(7 downto 0);  -- zapisovana data
   OUT_BUSY : in std_logic;                       -- pokud OUT_BUSY='1', LCD je zaneprazdnen, nelze zapisovat,  OUT_WREN musi byt '0'
   OUT_WREN : out std_logic                       -- LCD <- OUT_DATA pokud DATA_WREN='1' a OUT_BUSY='0'
 );
end cpu;


-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of cpu is
	signal pc_current, cnt_current : std_logic_vector(11 downto 0);
	signal ptr_current : std_logic_vector(9 downto 0); 
	signal pc_inc, pc_dec, cnt_inc, cnt_dec, ptr_inc, ptr_dec : std_logic;
	signal multiplexor_data : std_logic_vector(1 downto 0);
	type states is (
		state_null,
		state_reset, state_start,
		state_make_readable, state_elem_next, state_elem_previous, state_inc_value_load, state_inc_value_init, state_inc_value_do, 
		state_dec_value_load, state_dec_value_init, state_dec_value_do, state_print, state_load,
		state_while_start_decl, state_while_start_0, state_while_start_1, state_while_start_allowed, state_break_decl, state_break_init, state_break_allow,
		state_while_end_decl, state_while_end_0, state_while_end_1, state_while_end_2, state_while_end_allowed, 
		state_other
	);
	signal current_state, next_state : states; 
begin
-- Reading data from memory.
	OUT_DATA <= DATA_RDATA;
	CODE_ADDR <= pc_current;
	DATA_ADDR <= ptr_current;
-- CPU activity.
	current_state_proc: process (RESET, CLK, EN)
	begin
		if (RESET = '1') then
			current_state <= state_reset;
		elsif rising_edge(CLK) then
			if (EN = '1') then
				current_state <= next_state;
			end if;
		end if;
	end process current_state_proc;
-- Commands counter.
	PC: process (RESET, CLK)
	begin
		if (RESET = '1') then pc_current <= (others => '0');
		elsif rising_edge(CLK) then
			if (pc_inc = '1') then
				pc_current <= pc_current + 1;
			elsif (pc_dec = '1') then
				pc_current <= pc_current - 1;
			end if;
		end if;
	end process PC;
-- Memory pointer.
	PTR: process (RESET, CLK)
	begin
		if (RESET = '1') then ptr_current <= (others => '0');
		elsif rising_edge(CLK) then
			if (ptr_inc = '1') and (ptr_dec = '0') then
				ptr_current <= ptr_current + 1;
			elsif (ptr_inc = '0') and (ptr_dec = '1') then
				ptr_current <= ptr_current - 1;
			end if;
		end if;
	end process PTR;
-- Loop counter.
	CNT: process (RESET, CLK)
	begin
		if (RESET = '1') then
			cnt_current <= (others => '0');
		elsif rising_edge(CLK) then
			if (cnt_inc = '1') then
				cnt_current <= cnt_current + 1;
			elsif (cnt_dec = '1') then
				cnt_current <= cnt_current - 1;
			end if;
		end if;
	end process CNT;	
-- Write value.
	processing_ram: process (RESET, CLK, IN_DATA, DATA_RDATA)
	begin
		if (RESET = '1') then
			DATA_WDATA <= (others => '0');
		elsif rising_edge(CLK) then
				if (multiplexor_data) = "00" then
					DATA_WDATA <= IN_DATA; 
				elsif (multiplexor_data) = "01" then 
					DATA_WDATA <= DATA_RDATA + 1; 
				elsif (multiplexor_data) = "10" then 
					DATA_WDATA <= DATA_RDATA - 1;
				end if;
		end if;
	end process processing_ram;
-- State and output logics.
	next_process: process (current_state, cnt_current, OUT_BUSY, IN_VLD, CODE_DATA, DATA_RDATA)
	begin
		next_state 		  <= current_state;
		CODE_EN  		  <= '0';
		DATA_WREN 		  <= '0';
		DATA_EN 		  <= '0';
		IN_REQ 			  <= '0';
		OUT_WREN 		  <= '0';
		pc_inc 			  <= '0';
		pc_dec 			  <= '0';
		ptr_inc 		  <= '0';
		ptr_dec 		  <= '0';
		cnt_inc 		  <= '0';
		cnt_dec           <= '0';
		multiplexor_data <= "11";
		case current_state is
			when state_reset => next_state <= state_start;
			-- Dekoding.
			when state_start => 
				next_state <= state_make_readable;
				CODE_EN <='1';
			when state_make_readable =>
				case code_data is
					-- Null.
					when "00000000" => next_state <= state_null;
					-- ">"
					when "00111110" => next_state <= state_elem_next; 
					-- "<"
					when "00111100" => next_state <= state_elem_previous; 
					-- "+"
					when "00101011" => next_state <= state_inc_value_load; 
					-- "-"
					when "00101101" => next_state <= state_dec_value_load; 
					-- "."
					when "00101110" => next_state <= state_print; 
					-- ","
					when "00101100" => next_state <= state_load; 
					-- "["
					when "01011011" => next_state <= state_while_start_decl; 
					-- "]"
					when "01011101" => next_state <= state_while_end_decl; 
					-- "~"
					when "01111110" => next_state <= state_break_decl; 
					-- Others symbol.
					when others 	=> next_state <= state_other; 
				end case;
			-- Handle symbols.
			-- Null: stops.
			when state_null => next_state <= state_null;
			-- ">": next element.
			when state_elem_next => next_state <= state_start;
				ptr_inc <= '1'; 
				pc_inc <= '1'; 		
			-- "<": previous element.
			when state_elem_previous => next_state <= state_start;
				ptr_dec <= '1'; 
				pc_inc <= '1'; 
			-- "+": increments current cell.
			when state_inc_value_load => next_state <= state_inc_value_init; 
				DATA_EN <='1';
				DATA_WREN <= '0'; 
			when state_inc_value_init => next_state <= state_inc_value_do;
				multiplexor_data <= "01";
			when state_inc_value_do => next_state <= state_start;
				pc_inc <= '1';
				DATA_EN <= '1';
				DATA_WREN <= '1';
			-- "-": decrements current cell.
			when state_dec_value_load => next_state <= state_dec_value_init;
				DATA_EN <= '1';
				DATA_WREN <= '0';
			when state_dec_value_init => next_state <= state_dec_value_do;
				multiplexor_data <="10";
			when state_dec_value_do => next_state <= state_start;
				pc_inc <= '1';
				DATA_EN <= '1';
				DATA_WREN <= '1';
			-- ".": - prints current cell. 
			when state_print =>
				if (OUT_BUSY = '1') then next_state <= state_print;
					DATA_EN <= '1';
				else next_state <= state_start;
					pc_inc <= '1';
					OUT_WREN <= '1';
				end if;
			-- ",": read from keyboard to current cell.
			when state_load =>
				if (IN_VLD = '0') then next_state <= state_load;
					IN_REQ <= '1';
					multiplexor_data <= "00";
				else next_state <= state_start;
					pc_inc <= '1';
					DATA_EN <= '1';
					DATA_WREN <= '1';
				end if;
			-- "[": starts loop.
			when state_while_start_decl => next_state <= state_while_start_0;
				pc_inc <= '1';
				DATA_EN <= '1';
				DATA_WREN <= '0';
			when state_while_start_0 =>
				if (DATA_RDATA = (DATA_RDATA'range => '0')) then next_state <= state_while_start_1;
					cnt_inc <= '1';
					CODE_EN <= '1';
				else next_state <= state_start;
				end if;
			when state_while_start_1 =>
				if (DATA_RDATA = (cnt_current'range => '0')) then next_state <= state_while_start_1;
					cnt_inc <= '1';
					CODE_EN <= '1';
				else next_state <= state_while_start_allowed;
					if (CODE_DATA) = "01011011" then 
						cnt_inc <= '1';
					elsif (CODE_DATA) = "01011101" then 
						cnt_dec <= '1'; 
					end if;
					pc_inc <='1'; 
				end if;
			when state_while_start_allowed => next_state <= state_while_start_1;
				CODE_EN <= '1'; 
			-- "]": ends loop.
			when state_while_end_decl => next_state <= state_while_end_0;
				DATA_EN <= '1';
				DATA_WREN <= '0';
			when state_while_end_0 =>
				if (DATA_RDATA = (DATA_RDATA'range => '0')) then next_state <= state_start;
					pc_inc <= '1';
				else next_state <= state_while_end_allowed;
					cnt_inc <= '1'; 
					pc_dec <= '1'; 
				end if;
			when state_while_end_1 =>
				if (cnt_current = (cnt_current'range =>'0')) then next_state <= state_start;
					cnt_inc <='0';
					CODE_EN <= '0';
				else next_state <= state_while_end_2;
					if (CODE_DATA) = "01011101" then
						cnt_inc <= '1'; 
					elsif (CODE_DATA) = "01011011" then 
						cnt_dec <= '1'; 
					end if;
				end if;
			when state_while_end_2 => next_state <= state_while_end_allowed;
				if (cnt_current =(cnt_current'range => '0')) then
					pc_inc <= '1'; 
				else 
					pc_dec <='1';
				end if;
			when state_while_end_allowed => next_state <= state_while_end_1;
				CODE_EN <= '1';
			-- "~": breaks loop.
			when state_break_decl => next_state <= state_break_allow;
				cnt_inc <= '1';
				pc_inc <= '1';
			when state_break_init =>
				if (cnt_current =(cnt_current'range => '0')) then next_state <= state_start;
				else next_state <= state_break_allow;
					if (CODE_DATA) = "01011011" then 
						cnt_inc <='1';
					elsif (CODE_DATA) = "01011101" then 
						cnt_dec <= '1'; 
					end if;
					pc_inc <='1'; 
				end if;
			when state_break_allow => next_state <= state_break_init;
				CODE_EN <= '1';
			-- Others symbol.
			when state_other => next_state <= state_start;
				pc_inc <= '1';
		end case;
	end process next_process;
end behavioral;