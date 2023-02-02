pageextension 50031 "TP Salespersons/Purchasers" extends "Salespersons/Purchasers"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = all;
            }
        }
    }
}
