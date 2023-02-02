pageextension 59156 "MP Item Vendor Catalog" extends "Item Vendor Catalog"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Blanket Order Quantity"; Rec."Blanket Order Quantity")
            {
                ApplicationArea = all;
            }
            field("Blanket Order Outstanding Qty."; Rec."Blanket Order Outstanding Qty.")
            {
                ApplicationArea = all;
            }

            field("Safely Qty."; Rec."Safety Qty.")
            {
                ApplicationArea = all;
            }
        }
        modify("Item No.")
        {
            Visible = true;
        }
        moveafter("Variant Code"; "Item No.")
        moveafter("Vendor No."; "Vendor Item No.", "Lead Time Calculation")
    }

    actions
    {
        addafter("&Item Vendor")
        {
            action("Refresh Item reference")
            {
                Caption = 'Refresh Item reference';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemVendor: Record "Item Vendor";
                    ItemReference: Record "Item Reference";
                begin
                    ItemVendor.Reset();
                    if ItemVendor.FindFirst() then
                        repeat
                            ItemReference.Reset();
                            ItemReference.SetRange("Item No.", ItemVendor."Item No.");
                            ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Vendor);
                            ItemReference.SetRange("Reference Type No.", ItemVendor."Vendor No.");
                            if not ItemReference.FindFirst() then begin
                                ItemReference.Init();
                                ItemReference.Validate("Item No.", ItemVendor."Item No.");
                                ItemReference.Validate("Reference Type", ItemReference."Reference Type"::Vendor);
                                ItemReference.Validate("Reference Type No.", ItemVendor."Vendor No.");
                                ItemReference.Validate("Reference No.", ItemVendor."Vendor Item No.");
                                ItemReference.Insert();
                            end else begin
                                if ItemReference."Reference No." = '' then begin
                                    ItemReference.Delete();
                                end else begin
                                    ItemReference.Validate("Item No.", ItemVendor."Item No.");
                                    ItemReference.Validate("Reference Type", ItemReference."Reference Type"::Vendor);
                                    ItemReference.Validate("Reference Type No.", ItemVendor."Vendor No.");
                                    ItemReference.Validate("Reference No.", ItemVendor."Vendor Item No.");
                                    ItemReference.Modify();
                                end;
                            end;
                        until ItemVendor.Next() = 0;
                end;
            }
        }

    }

}
