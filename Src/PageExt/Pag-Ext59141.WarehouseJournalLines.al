pageextension 59141 "TP Warehouse Journal Lines" extends "Warehouse Journal Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Shelf No"; Rec."Shelf No")
            {
                ApplicationArea = all;
            }
            field("Replenishment System"; Rec."Replenishment System")
            {
                ApplicationArea = all;
            }

        }
    }

}
