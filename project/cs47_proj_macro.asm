# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#
# extracts from register at position
.macro extract_n($x, $pos)
srlv $v0, $x, $pos
and $v0, 1
.end_macro

# sets register at position to 1 
.macro set_n($x, $pos)
li $t0, 1
sllv $v0, $t0, $pos
or $v0, $v0, $x
.end_macro

# sets register at position with a 0 or 1
.macro set_n_with($source, $pos, $value)
bne $value, $zero, set_one
# case 0
set_n($value, $pos)     # stick a 1 in the middle of zeros (e.g. 0000100)
not $v0, $v0            # invert it (e.g. 11110111)
and $v0, $v0, $source   # AND it with the source to set the position to 0
j end_set_n_with
# case 1
set_one:
set_n($source, $pos)
end_set_n_with:
.end_macro