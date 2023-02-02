pageextension 59148 "TP Sales Quote" extends "Sales Quote"
{
    layout
    {
        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = all;
            }
            field("Ship To Phone No"; Rec."Ship-to Phone No.")
            {
                ApplicationArea = all;
            }

        }

        addafter("External Document No.")
        {
            field("Temp Out"; Rec."Temp Out")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        addfirst(General)
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
            field("Machine Model"; Rec."Machine Model")
            {
                ApplicationArea = all;
            }
        }


        addlast(General)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
                Importance = Additional;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
                Importance = Additional;
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
                Importance = Additional;
            }

        }
        modify("Sell-to Customer No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Sell-to Contact No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Sell-to Contact")
        {
            Visible = true;
            Importance = Promoted;
        }
        moveafter("Machine Model"; "Sell-to Customer No.")
        moveafter("Sell-to Customer No."; "Sell-to Contact No.")
        moveafter("Sell-to Contact No."; "Sell-to Contact")
        moveafter("Sell-to Contact"; "Sell-to Customer Name")
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
        }
        modify("Sell-to City")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Order Date")
        {
            Visible = true;
            Importance = Promoted;
        }
        moveafter("Sell-to Customer Name 2"; "Sell-to City")
        moveafter("Sell-to City"; "Order Date")
        modify("Due Date")
        {
            Importance = Additional;
        }
        modify("Document Date")
        {
            Importance = Promoted;
        }
        moveafter("Order Date"; "Document Date")
        moveafter("Document Date"; "Requested Delivery Date")
        modify("Salesperson Code")
        {
            Importance = Promoted;
        }
        moveafter("Requested Delivery Date"; "Salesperson Code")
        moveafter("Salesperson Code"; "External Document No.")
        modify("Campaign No.")
        {
            Importance = Promoted;
        }
        modify("Opportunity No.")
        {
            Importance = Promoted;
        }
        modify("Your Reference")
        {
            Importance = Promoted;
        }
        moveafter("External Document No."; "Campaign No.")
        moveafter("Campaign No."; "Opportunity No.")
        moveafter("Opportunity No."; "Your Reference")
        moveafter("Your Reference"; Status)
        addafter(Status)
        {
            field("Quotes Line Discount"; Rec."Quotes Line Discount")
            {
                ApplicationArea = all;
            }
        }
        modify("No.")
        {
            Visible = true;
        }
        movebefore("Order Type"; "No.")
    }

    actions
    {
        addafter(Print)
        {
            action("Print Sales Quote In English")
            {
                Caption = 'Print Sales Quote In English';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category9;

                trigger OnAction()
                var
                    ENSalesQuote: Report "EN Sales Quote";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Document Type", Rec."Document Type"::Quote);
                    SalesHeader.SetRange("No.", Rec."No.");
                    ENSalesQuote.SetTableView(SalesHeader);
                    ENSalesQuote.RunModal();
                end;
            }
            action("Print Sales Quote In Chinese")
            {
                Caption = 'Print Sales Quote In Chinese';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category9;

                trigger OnAction()
                var
                    CNSalesQuote: Report "CN Sales Quote";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Document Type", Rec."Document Type"::Quote);
                    SalesHeader.SetRange("No.", Rec."No.");
                    CNSalesQuote.SetTableView(SalesHeader);
                    CNSalesQuote.RunModal();
                end;
            }
        }
    }

    var
        TPUtilities: Codeunit "TP Utilities";

}
