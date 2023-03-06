pageextension 59014 "TP Customer Card" extends "Customer Card"
{
    layout
    {
        //General Tab
        modify("Name 2") { Visible = true; }
        moveafter(Name; "Name 2")
        //Invoicing tab
        modify("Intrastat Partner Type") { Visible = false; }
        modify("EORI Number") { Visible = false; }
        modify(GLN) { Visible = false; }
        modify("Use GLN in Electronic Document") { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Liable") { Visible = false; }
        modify("Invoice Disc. Code") { Visible = false; }
        //Payment Tab
        modify("Prepayment %") { Visible = false; }

        //Komax Extension Fields-----------
        addlast(General)
        {
            group(Komax)
            {
                Caption = 'Komax Extension';
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = all;
                }
                field("City (CN)"; Rec."City (CN)")
                {
                    ApplicationArea = all;
                }
                field("Sales Person"; Rec."Sales Person")
                {
                    ApplicationArea = all;
                }
                field("Service Person"; Rec."Service Person")
                {
                    ApplicationArea = all;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = all;
                }
                field(Segementation; Rec.Segementation)
                {
                    ApplicationArea = all;
                }
                field("Invoice Copies"; Rec."Invoice Copies")
                {
                    ApplicationArea = all;
                }
                field("Geo Location"; Rec."Geo Location")
                {
                    ApplicationArea = all;
                }
            }
        }
        addlast(Invoicing)
        {
            group(Komax2)
            {
                Caption = 'Komax Extension';
                field("Bill-to Department"; Rec."Bill-to Department")
                {
                    ApplicationArea = all;
                }
                field("Bill to Contact"; Rec."Bill to Contact")
                {
                    ApplicationArea = all;
                }
                field("Bill to Address"; Rec."Bill to Address")
                {
                    ApplicationArea = all;
                }
                field("Bill to Contact Phone No."; Rec."Bill to Contact Phone No.")
                {
                    ApplicationArea = all;
                }
                field("Bill to Contact Telex No."; Rec."Bill to Contact Telex No.")
                {
                    ApplicationArea = all;
                }
            }
        }
        addlast(Payments)
        {
            group(Komax3)
            {
                Caption = 'Komax Extension';
                field("Advance Payment %"; Rec."Advance Payment %")
                {
                    ApplicationArea = all;
                }
            }
        }
        //Dimension Fields
        addafter(Shipping)
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 3 Code"; Rec."Global Dimension 3 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 4 Code"; Rec."Global Dimension 4 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 5 Code"; Rec."Global Dimension 5 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 6 Code"; Rec."Global Dimension 6 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 7 Code"; Rec."Global Dimension 7 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 8 Code"; Rec."Global Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
            }
        }
        addbefore("Last Date Modified")
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
        }
        // movebefore("Service Person"; "Salesperson Code")
    }

    //Deposit1.00
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Advance Payment %" := 100;
    end;

    var
        TPUtilities: Codeunit "TP Utilities";
}
