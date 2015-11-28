with Ada.Text_IO;
use Ada.Text_IO;

package body Partie is

   procedure Joue_Partie(E : in out Etat; J : in Joueur) is
   begin
      Affiche_Jeu(E);
      if Est_Nul(E) then
         Put_Line("Match nul");
      elsif Est_Gagnant(E,Adversaire(J)) then
         Put("Victoire de ");
         if J=Joueur1 then
            Put_Line(Nom_Joueur2);
         else
            Put_Line(Nom_Joueur1);
         end if;
      elsif Est_Gagnant(E,J) then
         Put("Victoire de ");
         if J=Joueur1 then
            Put_Line(Nom_Joueur1);
         else
            Put_Line(Nom_Joueur2);
         end if;
         Affiche_Jeu(E);
      elsif J=Joueur1 then
		Put(Nom_Joueur1);
         E:=Etat_Suivant(E,Coup_Joueur1(E));
		Joue_Partie(E,Adversaire(J));
      else
		Put(Nom_Joueur2);
         E:=Etat_Suivant(E,Coup_Joueur2(E));
		 Joue_Partie(E,Adversaire(J));
      end if;
   end Joue_Partie;
end Partie;
