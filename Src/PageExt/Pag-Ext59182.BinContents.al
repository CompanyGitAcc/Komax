pageextension 59182 "TP Bin Content List" extends "Bin Contents List"
{
    layout
    {
        modify("Bin Type Code")
        {
            Visible = true;
        }
        moveafter("Item No."; "Bin Type Code")
        addafter("Quantity (Base)")
        {
            field("Pick Qty."; Rec."Pick Qty.")
            {
                ApplicationArea = all;
            }

            field("Pick Quantity (Base)"; Rec."Pick Quantity (Base)")
            {
                ApplicationArea = all;
            }
        }
    }


}
