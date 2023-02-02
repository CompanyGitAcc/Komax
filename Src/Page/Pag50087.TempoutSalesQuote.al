page 50087 "Temp out  Sales Quote"
{
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Quote), "Temp Out" = const(true), "Type" = const(Item));
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        SalesQuotePage: Page "Sales Quote";
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.SetRange("Document Type", Rec."Document Type");
                        SalesHeader.SetRange("No.", Rec."Document No.");
                        SalesQuotePage.SetTableView(SalesHeader);
                        SalesQuotePage.RunModal();
                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Salesperson Code - Quote"; Rec."Salesperson Code - Quote")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        // Rec.SetFilter("Temp Out", '*%1*', '临时出库');
    end;
}

