NAME	= ASC

COMPILE		= nasm -F dwarf -f elf64 

LINK		= ld $(OBJ) Biblioteca.o -o $(NAME)

SRC	= fc61810_Detetar.asm # fc61810_Aplicar.asm

OBJ	= $(SRC:.asm=.o)

CLR_RMV		:= \033[0m
RED		    := \033[1;31m
GREEN		:= \033[1;32m
YELLOW		:= \033[1;33m
BLUE		:= \033[1;34m
CYAN 		:= \033[1;36m

all:	$(NAME)

$(NAME):
	@$(COMPILE) $(SRC)
	@echo "$(YELLOW)$(COMPILE) ${CLR_RMV}of ${RED} Detetar ${CLR_RMV}..."
	@echo "$(BLUE)Detetar created[0m ✔️"
	@$(LINK)
	@echo "$(CYAN)program linked[0m ✔️"

run:	all
	@echo "$(YELLOW)Running ${CLR_RMV}${RED}Detetar ${CLR_RMV}"
	@./$(NAME) fcul_mod_R.bmp

clean:		
	@rm -f $(OBJ)
	@echo "$(RED)Deleting $(CYAN)$(OBJ) ✔️"

fclean:	clean
	rm -f $(NAME)
	@echo "$(RED)Deleting $(CYAN)$(NAME) ✔️"

re:			fclean $(NAME)

.PHONY:	all clean fclean re