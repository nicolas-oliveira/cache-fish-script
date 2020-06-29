function cache --description "Pacman Cache System in one command"
    set numberArg (count $argv);
    function countPackage
        set cachePackages (ls /var/cache/pacman/pkg/ | wc -l);
        set pacmanCache (du -sh /var/cache/pacman/pkg/ | cut -c1,2,3,4);
        set homeCache (du -sh /home/$USER/.cache/ | cut -c1,2,3,4)
        
        set pacmanSum (du --max-depth=0 /var/cache/pacman/pkg/ | cut -d '/' -f 1)
        set homeSum (du --max-depth=0 /home/$USER/.cache/ | cut -d '/' -f 1)
        
        set SumOfCache (math (math  $pacmanSum+$homeSum)/1000000)
        
        printf "\n\033[1;34m $cachePackages \033[0m - Pacotes em cache\n";
        printf "\033[1;34m $pacmanCache \033[0m - Tamanho do cache em /var/cache/\n";
        printf "\033[1;34m $homeCache \033[0m - Tamanho do cache em /home/$USER/.cache/\n\n";
        printf "\033[1;31m $SumOfCache GB\033[0m - Tamanho total do cache do sistema\n\n";
     end
	
	for option in $argv
	   switch "$option"
             case -c clear
             	sudo paccache -r;
             	countPackage;
             case -c1
                sudo paccache -rk1;
                countPackage;
             case -u 
                sudo paccache -ruk0;
                countPackage;
             case -uu
                pacman -Sc;
                countPackage;
             case -o
	        sudo pacman -Rns (pacman -Qtdq);
	        countPackage;
             case -s show
                ncdu /var/cache/pacman/pkg/;
             case --force
                sudo pacman -Scc;
                countPackage;
             case -h help
	        printf "\nUse os parâmetros a seguir para limpar o cache:\n";
                printf "\033[1;34m clear ou -c \033[0m - Limpa os pacotes antigos (Mantém os 3 recentes)\n";
                printf "\033[1;34m -c1 \033[0m - Limpa os pacotes antigos (Mantém o último recente)\n";
                printf "\033[1;34m -u \033[0m - Limpa TODOS os pacotes desinstalados\n";
                printf "\033[1;34m -uu \033[0m - Limpa TODOS os pacotes não instalados e os banco de dados não usados\n";
                printf "\033[1;34m -o \033[0m - Limpa TODOS os pacotes órfãos\n";
                printf "\033[1;34m show ou -s \033[0m - Abre o gerenciador em ordem crescente\n";
                printf "\033[1;34m --force \033[0m - Limpa TODOS os pacotes em cache\n\n";
                printf "\033[1;33mAtenção:\033[0m Deve-se evitar apagar do cache todas as versões anteriores dos pacotes instalados e todos os pacotes desinstalados, a menos que se necessita desesperadamente liberar algum espaço em disco. Isso impedirá o downgrade ou a reinstalação de pacotes sem baixá-los novamente.\n\n";
             case \*
               printf "error: Opção desconhecida: %s\n" $option
               printf "Digite 'cache -h' ou 'cache help' para mais detalhes\n\n";
	   end
	end

	if test $numberArg = 0
	  countPackage;
	end
	  
end
 
