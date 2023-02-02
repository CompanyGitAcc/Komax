pageextension 59117 "TP Assembly BOM" extends "Assembly BOM"
{
    layout
    {
        addlast(Control1)
        {
            field("Item Translation"; Rec."Item Translation")
            {
                ApplicationArea = all;
            }

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;
    end;

}
