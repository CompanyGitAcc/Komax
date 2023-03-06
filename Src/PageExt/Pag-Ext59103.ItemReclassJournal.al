pageextension 59103 "TP Item Reclass Journal" extends "Item Reclass. Journal"
{
    layout
    {
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Bin Code")
        {
            Visible = true;
        }
        modify("New Bin Code")
        {
            Visible = true;
        }
        movelast(Control1; "Applies-to Entry")

        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                BinContent: Record "Bin Content";
            begin
                IF Item.Get(Rec."Item No.") then begin
                    BinContent.Reset();
                    BinContent.SetRange("Item No.", Item."No.");
                    BinContent.SetRange("Location Code", Rec."Location Code");
                    BinContent.SetRange(Default, true);
                    if BinContent.FindFirst() then
                        Rec."Bin Code" := BinContent."Bin Code";
                end;
                Rec.Validate("New Location Code", '');
            end;
        }
    }

    actions
    {
        addafter("&Line")
        {

        }
    }

}
