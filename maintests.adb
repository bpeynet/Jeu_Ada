with Liste_Generique;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with System.Address_To_Access_Conversions;

procedure MainTests is

   procedure test(I : Integer) is
   begin
      Put(I,1);
   end test;

   package H is new Liste_Generique(Element => Integer,
                                    Put => test);
   use H;
   L : Liste;
begin
   Put_Line("------------ Début des tests ------------");
   L := Creer_Liste;
   Insere_Tete(2,L);
   Insere_Tete(3,L);
   Insere_Tete(4,L);
   Insere_Tete(1,L);
   Affiche_Liste(L);
   Libere_Liste(L);
   Put_Line("Ca c'est fait");
   --Put(To_Address(L));
   Put_Line("Après");
   Affiche_Liste(L);
end MainTests;
