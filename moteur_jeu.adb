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

   function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur)
                         return Integer is
      L: Liste;
      It: Iterateur;
      Nouvel_Etat: Etat;
      Estimation, Meilleur: Integer;
   begin
      Nouvel_Etat:=Etat_Suivant(E,C);
      if P=0 then return Eval(Nouvel_Etat);
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
