page 50092 "Edit Reservation Entries"
{
    Caption = 'Reservation Entries';
    PageType = List;
    SourceTable = "Reservation Entry";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Reservation Status"; Rec."Reservation Status") { ApplicationArea = All; }

                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Lot No."; Rec."Lot No.") { ApplicationArea = All; }
                field("Source ID"; Rec."Source ID") { ApplicationArea = All; }
                field("Source Ref. No."; Rec."Source Ref. No.") { ApplicationArea = All; }
                field("Source Prod. Order Line"; Rec."Source Prod. Order Line") { ApplicationArea = All; }
                field("Source Type"; Rec."Source Type") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Delete")
            {
                Caption = 'Delete';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ReservationEntry: Record "Reservation Entry";
                begin
                    if not Confirm('Will you confirm to delete?') then exit;
                    ReservationEntry.Reset();
                    ReservationEntry.setrange("Entry No.", Rec."Entry No.");
                    if ReservationEntry.FindFirst() then
                        ReservationEntry.DeleteAll();
                end;
            }
        }
    }
}
