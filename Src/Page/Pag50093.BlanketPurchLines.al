page 50093 "Blanket Purch. Lines"
{
    Caption = 'Blanket Purchase Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = const("Blanket Order"));

    layout
    {
        area(content)
        {
            repeater(Group1)
            {
                field("Document Type"; Rec."Document Type")
                {
                    StyleExpr = StyleTxt;
                }
                field("Document No."; Rec."Document No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    StyleExpr = StyleTxt;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    StyleExpr = StyleTxt;
                }
                field("No."; Rec."No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    StyleExpr = StyleTxt;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = true;
                    StyleExpr = StyleTxt;
                }
                field(Quantity; Rec.Quantity)
                {
                    StyleExpr = StyleTxt;
                }
                field(POQty; POQty)
                {
                    StyleExpr = StyleTxt;
                }
                field(SaftyQty; SaftyQty)
                {
                    StyleExpr = StyleTxt;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("Show Document")
                {
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PurchHeader.GET(Rec."Document Type", Rec."Document No.");
                        CASE Rec."Document Type" OF
                            Rec."Document Type"::Quote:
                                Page.RUN(Page::"Purchase Quote", PurchHeader);
                            Rec."Document Type"::Order:
                                Page.RUN(Page::"Purchase Order", PurchHeader);
                            Rec."Document Type"::Invoice:
                                Page.RUN(Page::"Purchase Invoice", PurchHeader);
                            Rec."Document Type"::"Return Order":
                                Page.RUN(Page::"Purchase Return Order", PurchHeader);
                            Rec."Document Type"::"Credit Memo":
                                Page.RUN(Page::"Purchase Credit Memo", PurchHeader);
                            Rec."Document Type"::"Blanket Order":
                                Page.RUN(Page::"Blanket Purchase Order", PurchHeader);
                        END;
                    end;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        ItemVendor: Record "Item Vendor";
    begin
        StyleTxt := '';
        POQty := 0;
        SaftyQty := 0;
        if ItemVendor.Get(Rec."Buy-from Vendor No.", Rec."No.", Rec."Variant Code") then
            SaftyQty := ItemVendor."Safety Qty.";
        PurchLine.SetRange("Blanket Order No.", Rec."Document No.");
        PurchLine.SetRange("Blanket Order Line No.", Rec."Line No.");
        if PurchLine.FindFirst() then
            repeat
                POQty := POQty + PurchLine.Quantity;
            until PurchLine.Next() = 0;

        if (Rec.Quantity - POQty) < SaftyQty then
            StyleTxt := 'ATTENTION';
    end;

    trigger OnOpenPage()
    begin
        // Rec.SETFILTER("Expected Receipt Date", '<%1', TODAY);
        // Rec.SETFILTER("Outstanding Quantity", '>%1', 0);
    end;

    var
        PurchHeader: Record "Purchase Header";
        DueDate: Date;
        POQty: Decimal;
        SaftyQty: Decimal;
        StyleTxt: Text[10];
}

