with Ada.Text_IO; 
with Ada.Integer_Text_IO;
with Puissance4;
with Participant;
with Partie;
with Liste_Generique;
--with Moteur_Jeu;

use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;

procedure Main2Joueurs is
   
   package MyPuissance4 is new Puissance4(4,4,3);
   Nom1, Nom2: String(1..20);
   Last1,Last2: Natural;
   begin
   Put("Entrez le nom du joueur 1: ");
   Get_Line(Nom1,Last1);
   Put("et le nom du joueur 2: ");
   Get_Line(Nom2,Last2);
   
   declare
   -- definition d'une partie entre L'ordinateur en Joueur 1 et un humain en Joueur 2
   package MyPartie is new Partie(MyPuissance4.Etat,
				  MyPuissance4.Coup, 
				  Nom1(1..Last1),
				  Nom2(1..Last2),
				  MyPuissance4.Jouer,
				  MyPuissance4.Est_Gagnant,
				  MyPuissance4.Est_Nul,
				  MyPuissance4.Afficher,
				  MyPuissance4.Affiche_Coup,
				  MyPuissance4.Demande_Coup_Joueur1,
				  MyPuissance4.Demande_Coup_Joueur2);
   use MyPartie;
   
   P: MyPuissance4.Etat;

	begin
   --Put(3,0);
   Put_Line("3x3 - Puissance 4");
   --Put_Line("");New_Line;
   Put_Line(Nom1(1..Last1) & " : X"); 
   Put_Line(Nom2(1..Last2) & " : O");
   
   MyPuissance4.Initialiser(P);
   
   Joue_Partie(P, Joueur2);
   end;
end Main2Joueurs;
