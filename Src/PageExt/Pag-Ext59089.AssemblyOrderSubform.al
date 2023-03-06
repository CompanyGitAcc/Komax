pageextension 59089 "TP Assembly Order Subform" extends "Assembly Order Subform"
{
    layout
    {

        modify("Bin Code")
        {
            Visible = true;
        }
        //--YK004
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                BinContent: Record "Bin Content";
            begin
                IF Item.Get(Rec."No.") then begin
                    BinContent.Reset();
                    BinContent.SetRange("Item No.", Item."No.");
                    BinContent.SetRange("Location Code", Rec."Location Code");
                    BinContent.SetRange(Default, true);
                    if BinContent.FindFirst() then
                        Rec."Bin Code" := BinContent."Bin Code";
                end;

                Rec.Validate("Location Code", '');
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                BinContent: Record "Bin Content";
            begin
                IF Item.Get(Rec."No.") then begin
                    BinContent.Reset();
                    BinContent.SetRange("Item No.", Item."No.");
                    BinContent.SetRange("Location Code", Rec."Location Code");
                    BinContent.SetRange(Default, true);
                    if BinContent.FindFirst() then
                        Rec."Bin Code" := BinContent."Bin Code";
                end;
            end;
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.Validate("Location Code", '');
    end;
}
