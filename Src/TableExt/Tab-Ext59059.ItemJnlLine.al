tableextension 59059 "TP Item Journal Line" extends "Item Journal Line"
{
    //#费用分摊#
    fields
    {

        field(50002; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        field(50003; "New Location Name"; text[100])
        {
            Caption = 'New Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("New Location Code")));
        }
        // field(50008; "Prepared By"; Text[100])
        // {
        //     Caption = 'Prepared By';
        //     TableRelation = Employee;
        // }
        field(50009; Remark; Text[250])
        {
            Caption = 'Remark';
            TableRelation = Employee;
        }
        field(50010; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            TableRelation = Employee;
        }
        field(50011; "Komax Reason Code"; Code[20])
        {
            Caption = 'Komax Reason Code';
            TableRelation = Employee;
        }
        field(50012; "Shelf No."; Code[20])
        {
            Caption = 'Shelf No.';
            TableRelation = Employee;
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                StockkeepingUnit: Record "Stockkeeping Unit";
            begin
                //#1-1
                IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
                    IF StockkeepingUnit.GET("Location Code", "Item No.", "Variant Code") THEN
                        "Shelf No." := StockkeepingUnit."Shelf No.";
                END;
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                StockkeepingUnit: Record "Stockkeeping Unit";
            begin
                //#1-2
                IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
                    IF StockkeepingUnit.GET("Location Code", "Item No.", "Variant Code") THEN
                        "Shelf No." := StockkeepingUnit."Shelf No.";
                END;
            end;
        }
        modify("Variant Code")
        {
            trigger OnAfterValidate()
            var
                StockkeepingUnit: Record "Stockkeeping Unit";
            begin
                IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
                    IF StockkeepingUnit.GET("Location Code", "Item No.", "Variant Code") THEN
                        "Shelf No." := StockkeepingUnit."Shelf No.";
                END;
            end;
        }
    }

}
