tableextension 59091 "TP Warehouse Activity Header" extends "Warehouse Activity Header"
{
    fields
    {
        field(50000; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Activity Line"."Source No." WHERE("No." = FIELD("No.")));
        }
        field(50001; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Activity Line"."Whse. Document No." WHERE("No." = FIELD("No.")));
        }
        field(50002; "Customr No."; Code[20])
        {
            Caption = 'Customr No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Activity Line"."Destination No." WHERE("No." = FIELD("No."), "Destination Type" = FILTER(Customer)));
        }
        field(50003; "Put-away Bin Code"; Code[20])
        {
            Caption = 'Put-away Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));

            trigger OnValidate()
            var
                WarehouseActivityLine: Record "Warehouse Activity Line";
                Bin: Record Bin;
            begin
                if Confirm(Text01) then begin
                    Bin.get(Rec."Location Code", Rec."Put-away Bin Code");
                    WarehouseActivityLine.Reset();
                    WarehouseActivityLine.SetRange("No.", "No.");
                    WarehouseActivityLine.SetRange("Activity Type", Type);
                    WarehouseActivityLine.SetRange("Action Type", WarehouseActivityLine."Action Type"::Place);
                    if WarehouseActivityLine.FindFirst() then
                        repeat
                            WarehouseActivityLine."Zone Code" := Bin."Zone Code";
                            WarehouseActivityLine."Bin Code" := "Put-away Bin Code";
                            WarehouseActivityLine.Modify();
                        until WarehouseActivityLine.Next() = 0;
                end;
            end;
        }
        field(50004; "Create Date"; Date)
        {
            Caption = 'Create Date';
        }
        field(50005; "Document Status"; Option)
        {
            Caption = 'Document Status';
            OptionCaption = ' ,Partially Picked,Partially Shipped,Completely Picked,Completely Shipped';
            OptionMembers = " ","Partially Picked","Partially Shipped","Completely Picked","Completely Shipped";
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Shipment Header"."Document Status" WHERE("No." = FIELD("Shipment No.")));
        }



    }

    var
        Text01: Label 'Will you modify bin code in lines';

}
