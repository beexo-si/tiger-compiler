structure tigerassem :> tigerassem =
struct

type reg = string
type temp = tigertemp.temp
type label = tigertemp.label


datatype instr = OPER of {assem: string,
                          dst: temp list,
                          src: temp list,
                          jump: label list option}
               | aLABEL of {assem: string,
                           lab: label}
               | MOV of {assem: string,
                          dst: temp,
                          src: temp}
                          
fun format _ ins = ""
	(*COMPLETAR*)

end
