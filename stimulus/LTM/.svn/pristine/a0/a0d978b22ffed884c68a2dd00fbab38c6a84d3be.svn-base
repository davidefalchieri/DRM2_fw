LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

PACKAGE io_utils IS

    PROCEDURE write_string(l : INOUT line;
                           value : IN string;
                           justified : IN side := right;
                           field : IN width := 0);

    PROCEDURE read_string(l : INOUT line;
                          value : OUT string);

    TYPE radix IS (binary, octal, decimal, hex);

    -- read a number from the line
    -- use this if you have hex numbers that are not in VHDL pound-sign format
    PROCEDURE read_num(l : INOUT line; value : OUT integer;  radix : IN positive);

    -- read a number that might be in VHDL pound-sign format
    PROCEDURE read_based(l : INOUT line; value : OUT integer);

    PROCEDURE write_num(l : INOUT line;
                        value : IN bit_vector;
                        justified : IN side := right;
                        field : IN width := 0;
                        base : IN radix;
                        use_pound : boolean := false);

    PROCEDURE write_num(l : INOUT line;
                        value : IN std_logic_vector;
                        justified : IN side := right;
                        field : IN width := 0;
                        base : IN radix;
                        use_pound : boolean := false);

    PROCEDURE write_num(l : INOUT line;
                        value : IN integer;
                        justified : IN side := right;
                        field : IN width := 0;
                        base : IN radix;
                        use_pound : boolean := false);
END io_utils;

PACKAGE BODY io_utils IS

    -- ********************************************************************************
    PROCEDURE write_string(l : INOUT line;
                           value : IN string;
                           justified : IN side := right;
                           field : IN width := 0)
    IS
    BEGIN
        write(l, value, justified, field);
    END;

    PROCEDURE read_string(l : INOUT line;
                          value : OUT string)
    IS
    BEGIN
        read(l, value);
    END;




    PROCEDURE shrink_line(l : INOUT line; pos : integer) IS
        VARIABLE tmpl : line;
    BEGIN
        tmpl := l;
        l := NEW string'(tmpl(pos TO tmpl'high));
        deallocate(tmpl);
    END;

    -- ********************************************************************************
    PROCEDURE read_num(l : INOUT line;
                       value : OUT integer;
                       radix : IN positive)
    IS
        CONSTANT not_digit : integer := -999;

        -- convert a character to a value from 0 to 15
        FUNCTION digit_value(c : character) RETURN integer IS
        BEGIN
            IF (c >= '0') AND (c <= '9') THEN
                RETURN (character'pos(c) - character'pos('0'));
            ELSIF (c >= 'a') AND (c <= 'f') THEN
                RETURN (character'pos(c) - character'pos('a') + 10);
            ELSIF (c >= 'A') AND (c <= 'F') THEN
                RETURN (character'pos(c) - character'pos('A') + 10);
            ELSE
                RETURN not_digit;
            END IF;
        END;

        -- skip leading white space in the line
        PROCEDURE skip_white(VARIABLE l : IN line; pos : OUT integer) IS
        BEGIN
            pos := l'low;
            FOR i IN l'low TO l'high LOOP
                CASE l(i) IS
                    WHEN ' ' | ht  =>
                        pos := i + 1;
                    WHEN OTHERS =>
                        EXIT;
                END CASE;
            END LOOP;
        END;

        VARIABLE digit : integer;
        VARIABLE result : integer := 0;
        VARIABLE pos : integer;
    BEGIN
        -- skip white space
        skip_white(l, pos);

        -- calculate the value
        FOR i IN pos TO l'right LOOP
            digit := digit_value(l(i));
            EXIT WHEN (digit = not_digit) OR (digit >= radix);
            result := result * radix + digit;
            pos := i + 1;
        END LOOP;
        value := result;

        -- remove the "used" characters from the line
        shrink_line(l, pos);
    END;

    -- ********************************************************************************
    PROCEDURE read_based(l : INOUT line; value : OUT integer) IS
        VARIABLE digit : integer;
        VARIABLE num : integer;
        VARIABLE base : integer;
    BEGIN
        read_num(l, num, 10);
        IF (l'length > 1) AND (l(l'left) = '#') THEN
            shrink_line(l, l'left+1);
            base := num;
            read_num(l, num, base);
            IF (l'length >= 1) AND (l(l'left) = '#') THEN
                shrink_line(l, l'left+1);
            END IF;
        END IF;
        value := num;
    END;

    -- ********************************************************************************
    PROCEDURE write_num(l : INOUT line;
                        value : IN bit_vector;
                        justified : IN side := right;
                        field : IN width := 0;
                        base : IN radix;
                        use_pound : boolean := false)
    IS
        FUNCTION to_int(bv : bit_vector) RETURN integer
        IS
            VARIABLE result : integer := 0;
        BEGIN
            FOR i IN bv'RANGE LOOP
                result := result * 2;
                IF (bv(i) = '1') THEN
                    result := result + 1;
                END IF;
            END LOOP;
            RETURN result;
        END;

        TYPE array_of_widths IS ARRAY(radix) OF natural;
        CONSTANT nibble_widths : array_of_widths := (
            binary => 1,
            octal  => 3,
            hex    => 4,
            decimal=> 32);
        CONSTANT hex_digit : string(1 TO 16) := "0123456789ABCDEF";

        ALIAS input_val : bit_vector(value'length DOWNTO 1) IS value;
        CONSTANT nibble_width : natural := nibble_widths(base);
        CONSTANT result_width : natural := (value'length + nibble_width - 1)/nibble_width;

        VARIABLE result : string(1 TO result_width);  -- longest possible value
        VARIABLE result_pos : positive := 1;
        VARIABLE nibble_val : integer;
        VARIABLE bitcnt : integer;
    BEGIN
        IF base = decimal THEN
            write_num(l, to_int(value), justified, field, base, use_pound);
            RETURN;
        END IF;

        bitcnt := value'length MOD nibble_width;
        IF (bitcnt = 0) THEN
            bitcnt := nibble_width;
        END IF;
        FOR i IN input_val'RANGE LOOP
            nibble_val := nibble_val * 2;
            IF (input_val(i) = '1') THEN
                nibble_val := nibble_val + 1;
            END IF;
            bitcnt := bitcnt - 1;
            IF (bitcnt = 0) THEN
                result(result_pos) := hex_digit(nibble_val + 1);
                result_pos := result_pos + 1;
                nibble_val := 0;
                bitcnt := nibble_width;
            END IF;
        END LOOP;
        write(l, result, justified, field);
    END;

    -- ********************************************************************************
    PROCEDURE write_num(l : INOUT line;
                        value : IN std_logic_vector;
                        justified : IN side := right;
                        field : IN width := 0;
                        base : IN radix;
                        use_pound : boolean := false)
    IS
    BEGIN
        write_num(l, to_BitVector(value), justified, field, base, use_pound);
    END;


    -- ********************************************************************************
    PROCEDURE write_num(l : INOUT line;
                        value : IN integer;
                        justified : IN side := right;
                        field : IN width := 0;
                        base : IN radix;
                        use_pound : boolean := false)
    IS

        VARIABLE tmp : line;
        VARIABLE slv_val : std_logic_vector(31 downto 0);
        VARIABLE pos,i : integer;
    BEGIN
        IF (base = decimal) THEN
            IF (use_pound) THEN
                write_string(tmp, "10#");
            END IF;
            write(tmp, value);
            IF (use_pound) THEN
                write_string(tmp, "#");
            END IF;
            write(l, tmp.ALL, justified, field);
            deallocate(tmp);
        ELSE
            -- Modifica di C. Tintori per aggiungere gli zeri in testa ai numeri hex
            -- quando field non è zero.
            slv_val := conv_std_logic_vector(value, 32);
            IF field = 0 then
                FOR i IN 31 downto 0 LOOP
                  IF slv_val(i) = '1' THEN
                    pos := i;
                    EXIT;
                  END IF;
                END LOOP;
            ELSE
                pos := field * 4 - 1;
            END IF;
            write_num(l, to_BitVector(slv_val(pos downto 0)), justified, field, base, use_pound);
        END IF;
    END;

END io_utils;



-- Example:

--ENTITY test IS END;
--
--USE std.textio.ALL;
--USE work.io_utils.ALL;
--ARCHITECTURE hex_test OF test IS
--BEGIN
--    PROCESS
--        VARIABLE val : integer;
--        FILE myfile : text IS IN "values";
--        VARIABLE inline : line;
--        VARIABLE outline : line;
--    BEGIN
--        WHILE NOT endfile(myfile) LOOP
--            readline(myfile, inline);
--
--            write_num(outline, inline.ALL);
--
--            read_based(inline, val);
--            write_string(outline, " binary: ");
--            write_num(outline, val, base => binary);
--            write_string(outline, " octal: ");
--            write_num(outline, val, base => octal);
--            write_string(outline, " decimal: ");
--            write_num(outline, val, base => decimal);
--            write_string(outline, " hex: ");
--            write_num(outline, val, base => hex);
--            writeline(output, outline);
--        END LOOP;
--        WAIT;
--    END PROCESS;
--END;


