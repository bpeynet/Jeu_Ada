with Ada.Text_IO;
use Ada.Text_IO;

package body Partie is

   function ToString(J: Joueur) return String is
   begin
      if J=Joueur1 then
         return Nom_Joueur1;
      elsif J=Joueur2 then
         return Nom_Joueur2;
      else
         return "Problème de nom de joueur";
      end if;
   end ToString;

   procedure Joue_Partie(E : in out Etat; J : in Joueur) is
   begin
      Affiche_Jeu(E);
      Skip_Line;
      if Est_Nul(E) then
         Put_Line("Match nul");
      elsif Est_Gagnant(E,Adversaire(J)) then
         Put_Line("Victoire de " & ToString(Adversaire(J)));
      elsif Est_Gagnant(E,J) then
         Put_Line("Victoire de " & ToString(J));
      elsif J=Joueur1 then
         E:=Etat_Suivant(E,Coup_Joueur1(E));
		Joue_Partie(E,Adversaire(J));
      else
         E:=Etat_Suivant(E,Coup_Joueur2(E));
		 Joue_Partie(E,Adversaire(J));
      end if;
   end Joue_Partie;
end Partie;
