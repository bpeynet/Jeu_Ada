with Ada.Text_IO; use Ada.Text_IO;
package body Moteur_Jeu is

   function Choix_Coup(E : Etat) return Coup is
      C: Coup;
      L : Liste;
      It : Iterateur;
      Estimation, Meilleur: Integer;
   begin
      New_Line;
      L:=Coups_Possibles(E,JoueurMoteur);
      It:=Creer_Iterateur(L);
      Meilleur:=-100;
      loop
         exit when not A_Suivant(It);
         Suivant(It);
         Estimation:=Eval_Min_Max(E,Profondeur,Element_Courant(It),JoueurMoteur);
         if Estimation>Meilleur then
            Meilleur:=Estimation;
            C:= Element_Courant(It);
         end if;
      end loop;
      Affiche_Coup(C);
      return C;
   end Choix_Coup;

   --Evalue la situation selon les coups faits.
   function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur) return Integer is
      L: Liste;
      It: Iterateur;
      Nouvel_Etat: Etat;
      Estimation, Meilleur: Integer;

   begin
      Nouvel_Etat:=Etat_Suivant(E,C);

	--Si on est à la profondeur fixé, on appelle la fonction évaluant la situation statique
      if P=0 then return Eval(Nouvel_Etat);

	--Sinon
	else
	
	--On parcourt tout les coups possibles (coups stockés dans la liste)
	for I in 1..L'size loop
		--Si c'est à l'ordiateur de jouer on remonte la situtation la plus favorable
		if( J== ...) then
			return
		
		--Si c'est au joueur humain de jouer on remonte la situtation la plus catstrophique
		elsif (J==...) then
			return
		end if;
	end loop;
	end if;


      elsif Est_Gagnant(Nouvel_Etat,J) then
         if J=JoueurMoteur then
            return 100;
         else
            return -100;
         end if;

      elsif Est_Nul(Nouvel_Etat) then return 0;

      else
         L:=Creer_Liste;
         L:=Coups_Possibles(Nouvel_Etat,Adversaire(J));
         It:=Creer_Iterateur(L);
         if A_Suivant(It) then
            Suivant(It);
            Meilleur:=Eval_Min_Max(Nouvel_Etat,P-1,Element_Courant(It),Adversaire(J));
            loop
               exit when not A_Suivant(It);
               Suivant(It);
               Estimation:=Eval_Min_Max(Nouvel_Etat,P-1,Element_Courant(It),Adversaire(J));
               if J=JoueurMoteur then
                  if Estimation>Meilleur then
                     Meilleur:=Estimation;
                  end if;
               else
                  if Estimation<Meilleur then
                     Meilleur:=Estimation;
                  end if;
               end if;
            end loop;
         end if;
         return Meilleur;
      end if;
   end Eval_Min_Max;

end Moteur_Jeu;
