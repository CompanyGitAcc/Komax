page 50030 "TP Purchase Order Lines"
{
    Caption = 'Purchase Order Lines';
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = sorting("Order Date") order(descending) where("Document Type" = const("Order"));
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown()
                    var
                        PurchOrderPage: Page "Purchase Order";
                    begin
                        PurchHeader.SetRange("Document Type", Rec."Document Type");
                        PurchHeader.SetRange("No.", Rec."Document No.");
                        PurchOrderPage.SetTableView(PurchHeader);
                        PurchOrderPage.RunModal();
                    end;
                }
                // field(OrderStatus; Rec.Status)
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                field("Order Date"; Rec."Order Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = Basic, Suite;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                // field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                // {
                //     ApplicationArea = Basic, Suite;
                // }
                // field(Purchaser; Rec.Purchaser)
                // {
                //     ApplicationArea = Basic, Suite;
                // }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    Caption = 'Purchaser Code';
                    ApplicationArea = Basic, Suite;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OrderStatus; Rec.OrderStatus)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Over-Receipt Code"; Rec."Over-Receipt Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Over-Receipt Quantity"; Rec."Over-Receipt Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Visible = true;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posted Purch. Inv. No."; Rec."Posted Purch. Inv. No.")
                {
                    applicationArea = Basic, Suite;
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
                Image = Line;
                /*
                action("Show Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        PurchHeader.Get(Rec."Document Type", Rec."Document No.");
                        PageManagement.PageRun(PurchHeader);
                    end;
                }
                */

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchHeader: Record "Purchase Header";
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        PurchHeader: Record "Purchase Header";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        PurchaserName: Text[100];
    // OrderDate: date;
    // Purchaser: Code[20];

    protected var
        ShortcutDimCode: array[8] of Code[20];
}


