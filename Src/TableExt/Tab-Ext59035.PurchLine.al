tableextension 59035 "TP Purchase Line" extends "Purchase Line"
{
    fields
    {

        field(50002; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }

        field(59002; OrderStatus; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59003; "Order Type"; Enum "Purchase Order Type")
        {
            Caption = 'Order Type';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Order Type" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59004; Purchaser; Code[20])
        {
            Caption = 'Purchaser';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Purchaser Code" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59005; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Buy-from Vendor Name" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59006; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Posting Date" where("No." = field("Document No.")));
        }

        modify("Item Reference No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Item.get("No.") then begin
                    Description := item.Description;
                    "Description 2" := item."Description 2";
                    "Description 3" := item."Description 3";
                end;
            end;
        }
        field(59009; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Global Dimension 3 Code");
            end;
        }


        field(50010; "Remark"; text[250])
        {
            Caption = 'Remark';
        }
        field(50011; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
        field(50012; "Vendor Item #"; text[250])
        {
            Caption = 'Vendor Item #';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Vendor Item No." WHERE("No." = FIELD("No.")));
        }
        field(50013; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Header"."Purchaser Code" WHERE("Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.")));
        }
        field(50014; "Shelf No."; Code[20])
        {
            Caption = 'Shelf No.';
            // TableRelation = "Shelf No."."Shelf No." WHERE("Item No." = FIELD("No."));
        }
        field(50015; "OC Date"; Date)
        {
            Caption = 'OC Date';
            trigger OnValidate()
            begin
                // lRecPH.GET("Document Type", "Document No.");
                // IF lRecPH."OC Date" = 0D THEN BEGIN
                //     lRecPH."OC Date" := "OC Date";
                //     lRecPH.MODIFY;
                // END;
            end;
        }
        field(50016; "Pre-Receipt Bin Code"; Code[20])
        {
            Caption = 'Pre-Receipt Bin Code';
            TableRelation = Bin.Code;
        }
        field(50017; "Drawing Status"; Option)
        {
            Caption = 'Drawing Status';
            OptionCaption = ' ,Released,In Change,In ReVersion';
            OptionMembers = " ","Released","In Change","In ReVersion";
        }
        field(50018; "Drawing"; text[200])
        {
            Caption = 'Drawing';
        }
        field(50019; "Komax CH Part#"; Code[20])
        {
            Caption = 'Komax CH Part#';
        }
        // field(50020; "Promise Delivery Date"; Date)
        // {
        //     Caption = 'Promise Delivery Date';
        // }
        field(50021; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(50022; "Description 3"; Text[50])
        {
            Caption = 'Description 3';
        }
        field(50023; "Posted Purch. Inv. No."; Code[20])
        {
            Caption = 'Posted Purch. Inv. No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Line"."Document No." where("Order No." = field("Document No."), "Order Line No." = field("Line No.")));
        }

        field(50031; "PO No."; Code[20])
        {
            Caption = 'PO No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Line"."Order No." where("Document No." = field("Receipt No.")));
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                PurchaseLine2: Record "Purchase Line";
            begin
                PurchaseLine2.Reset();
                PurchaseLine2.SetRange("Document Type", "Document Type"::"Blanket Order");
                PurchaseLine2.SetRange("No.", "No.");
                PurchaseLine2.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                if PurchaseLine2.FindFirst() then begin
                    "Blanket Order No." := PurchaseLine2."Document No.";
                    "Blanket Order Line No." := PurchaseLine2."Line No.";
                end;
            end;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                InventorySetup: Record "Inventory Setup";
                Text01: Label 'This order is a customs supervision order, and non customs supervision materials cannot be entered';
                Text02: Label 'This order is not under the supervision of the customs. You cannot enter materials under the supervision of the customs';
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine2: Record "Purchase Line";
                Status: Integer;
            begin
                Status := 0;
                if Item.get("No.") then begin
                    // if Item."Customs Supervision" = true then begin
                    InventorySetup.get();
                    // Validate("Location Code", InventorySetup."Default Custom Location");
                    if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, "Document No.") then begin
                        if (Item."Customs Supervision" = false) then begin
                            if PurchaseHeader."Customs Supervision" = true then begin
                                //Error(Text01);
                            end;
                        end else
                            if (Item."Customs Supervision" = true) then begin
                                PurchaseLine2.Reset();
                                PurchaseLine2.SetRange("Document Type", "Document Type"::Order);
                                PurchaseLine2.SetRange("Document No.", PurchaseHeader."No.");
                                if PurchaseLine2.FindFirst() then
                                    repeat
                                        if Item.get(PurchaseLine2."No.") then begin
                                            if Item."Customs Supervision" = false then begin
                                                Status := Status + 1;
                                                //Error(Text02);
                                            end;
                                        end;
                                    until PurchaseLine2.Next() = 0;
                                if Status = 0 then begin
                                    PurchaseHeader."Customs Supervision" := true;
                                    PurchaseHeader.Modify();
                                end;
                            end;
                    end;

                end;
            end;
        }
    }
    keys
    {
        key(Key19; "Order Date")
        {
        }
    }

    trigger OnAfterInsert()
    begin
        //SY16001-
        lRecPH.GET("Document Type", "Document No.");
        IF lRecPH."OC Date" <> 0D THEN
            "OC Date" := lRecPH."OC Date";
        //SY16001+
    end;

    var
        lRecPH: Record "Purchase Header";

}
