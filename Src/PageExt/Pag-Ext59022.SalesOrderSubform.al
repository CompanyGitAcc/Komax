pageextension 59022 "TP Sales Order Subform" extends "Sales Order Subform"
{
    //------------------------------------------------------------
    //#VOL1.00 - ALF - 2021/11/25
    //更改字段：Variant Code, Purchasing Code,......
    //增加功能：抓取销售订单行记录 GetSalesLines
    //------------------------------------------------------------    
    layout
    {
        modify("Unit Cost (LCY)") { Visible = true; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Tax Liable") { Visible = false; }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        addafter("Location Code")
        {
            field("Inventory"; Rec."Inventory")
            {
                Editable = false;
                ApplicationArea = all;
            }
            // //期初
            // field("Post Qty"; Rec."Post Qty")
            // { ApplicationArea = all; }
        }
        modify("Location Code")
        {
            ShowMandatory = NOT IsCommentLine;
        }

        modify("Appl.-from Item Entry")
        {
            Visible = true;
        }
        modify("Appl.-to Item Entry")
        {
            Visible = true;
        }
        modify("Line No.")
        {
            Visible = true;
        }

        movelast(Control1; "Appl.-from Item Entry", "Appl.-to Item Entry", "Line No.")

        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
            // field("Commision to Invoice"; Rec."Commision to Invoice")
            // {
            //     ApplicationArea = all;
            // }
            // field("Commision(Base)"; Rec."Commision(Base)")
            // {
            //     ApplicationArea = all;
            // }
            // field("Drop Vendor No."; Rec."Drop Vendor No.")
            // {
            //     ApplicationArea = all;
            // }
            // field("Altern. Part #"; Rec."Altern. Part #")
            // {
            //     ApplicationArea = all;
            // }
            // field("Machine No."; Rec."Machine No.")
            // {
            //     ApplicationArea = all;
            // }
            // field("BOM Version"; Rec."BOM Version")
            // {
            //     ApplicationArea = all;
            // }
            // field("Line Count"; Rec."Line Count")
            // {
            //     ApplicationArea = all;
            // }
            // field("Order Qty"; Rec."Order Qty")
            // {
            //     ApplicationArea = all;
            // }
            // field("Komax Reason Code"; Rec."Komax Reason Code")
            // {
            //     ApplicationArea = all;
            // }
            // field("Sales Type"; Rec."Sales Type")
            // {
            //     ApplicationArea = all;
            // }
            // field("Sales Commision (%)"; Rec."Sales Commision (%)")
            // {
            //     ApplicationArea = all;
            // }
            // field("Sales Order No"; Rec."Sales Order No")
            // {
            //     ApplicationArea = all;
            // }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        moveafter("Item Reference No."; Quantity)
        moveafter(Quantity; "Unit Price")
        addafter("Description 2")
        {
            field("VAT %"; Rec."VAT %")
            {
                ApplicationArea = all;
            }
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = all;
            }
        }

        addafter("Description 3")
        {
            field("Machine No."; Rec."Machine No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action("Split Line")
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Split Lines';
                Ellipsis = true;
                Image = Split;

                trigger OnAction()
                var
                    Err01: Label 'Insert Failed';
                    SalesLine: Record "Sales Line";
                begin
                    Rec.TestField("Qty. Shipped (Base)", 0);
                    SalesLine.Init;
                    SalesLine := Rec;
                    salesline."Line No." := Rec."Line No." + 10;
                    SalesLine.Validate(Quantity, 0);
                    if not SalesLine.insert then
                        repeat
                            SalesLine."Line No." := SalesLine."Line No." + 10;
                        until SalesLine.Insert();

                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SalesLineType: Enum "Sales Line Type";
    begin
        Rec.Type := SalesLineType::Item;
    end;

}
