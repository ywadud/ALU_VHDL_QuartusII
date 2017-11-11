LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lab6 IS
PORT(osc,resetn,w,x : IN STD_LOGIC;
 test            : OUT STD_LOGIC;
 u                : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
END lab6;

ARCHITECTURE Behavior OF lab6 IS
TYPE STATE IS (s0,s1,s2,s3,s4,s5,s6,s7);
SIGNAL y,yfsm : STATE;
SIGNAL z      : STD_LOGIC;
SIGNAL count : INTEGER RANGE 0 TO 16383;
BEGIN

--  DEBOUNCER
PROCESS (resetn,osc)
BEGIN
IF resetn = '0' THEN
count <= 0;
y <= s0;
ELSIF (osc'EVENT AND osc = '1') THEN
count <= count +1;
IF count = 16383 THEN
CASE y IS

WHEN s0 =>
IF w = '0' THEN
y <= s1;
ELSE
y <= s0;
END IF;
WHEN s1 =>
IF w='0' THEN
y <= s2;
ELSE
y <= s0;
END IF;
WHEN s2 =>
IF w='0' THEN
y <= s3;
ELSE
y <= s0;
END IF;
WHEN s3 =>
IF w='0' THEN
y <= s4;
ELSE
y <= s0;
END IF;
WHEN s4 =>
IF w='0' THEN
y <= s4;
ELSE
y <= s5;
END IF;
WHEN s5 =>
IF w='0' THEN
y <= s4;
ELSE
y <= s6;
END IF;
WHEN s6 =>
IF w='0' THEN
y <= s4;
ELSE
y <= s7;
END IF;
WHEN s7 =>
IF w='0' THEN
y <= s4;
ELSE
y <= s0;
END IF;
END CASE;
END IF;
END IF;
END PROCESS;
WITH y SELECT
z <= '1' WHEN s4,
 '1' WHEN s5,
 '1' WHEN s6,
 '1' WHEN s7,
 '0' WHEN OTHERS;
 test <= z;
---FSM
PROCESS (resetn,z)
BEGIN
IF resetn = '0' THEN yfsm <= s0;

ELSIF (z'EVENT AND z = '1') THEN

CASE yfsm  IS

WHEN s0 =>
IF x = '0' THEN
yfsm  <= s5;
ELSE
yfsm  <= s6;
END IF;

WHEN s1 =>
IF x='0' THEN
yfsm  <= s4;
ELSE
yfsm  <= s2;
END IF;

WHEN s2 =>
IF x='0' THEN
yfsm  <= s2;
ELSE
yfsm  <= s7;
END IF;

WHEN s3 =>
IF x='0' THEN
yfsm  <= s0;
ELSE
yfsm  <= s7;
END IF;

WHEN s4 =>
IF x='0' THEN
yfsm  <= s7;
ELSE
yfsm  <= s4;
END IF;

WHEN s5 =>
IF x='0' THEN
yfsm  <= s4;
ELSE
yfsm  <= s3;
END IF;

WHEN s6 =>
IF x='0' THEN
yfsm  <= s3;
ELSE
yfsm  <= s7;
END IF;

WHEN s7 =>
IF x='0' THEN
yfsm  <= s1;
ELSE
yfsm  <= s7;
END IF;

END CASE;
END IF;
END PROCESS;
WITH yfsm SELECT
u <= "1000000" WHEN s0,
 "1111001" WHEN s1,
 "0100100" WHEN s2,
 "0110000" WHEN s3,
 "0011001" WHEN s4,
 "0010010" WHEN s5,
 "0000011" WHEN s6,
 "1011000" WHEN s7;
END Behavior;
