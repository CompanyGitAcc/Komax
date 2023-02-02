tableextension 59069 "TP Default Dimension" extends "Default Dimension"
{
    trigger OnBeforeInsert()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        if "Dimension Code" = GLSetup."Shortcut Dimension 3 Code" then
            UpdateGlobalDimCode2(3, "Table ID", "No.", "Dimension Value Code");
        if "Dimension Code" = GLSetup."Shortcut Dimension 4 Code" then
            UpdateGlobalDimCode2(4, "Table ID", "No.", "Dimension Value Code");
        if "Dimension Code" = GLSetup."Shortcut Dimension 5 Code" then
            UpdateGlobalDimCode2(5, "Table ID", "No.", "Dimension Value Code");
        if "Dimension Code" = GLSetup."Shortcut Dimension 6 Code" then
            UpdateGlobalDimCode2(6, "Table ID", "No.", "Dimension Value Code");
        if "Dimension Code" = GLSetup."Shortcut Dimension 7 Code" then
            UpdateGlobalDimCode2(7, "Table ID", "No.", "Dimension Value Code");
        if "Dimension Code" = GLSetup."Shortcut Dimension 8 Code" then
            UpdateGlobalDimCode2(8, "Table ID", "No.", "Dimension Value Code");
    end;


    procedure UpdateGlobalDimCode2(GlobalDimCodeNo: Integer; TableID: Integer; AccNo: Code[20]; NewDimValue: Code[20])
    begin
        case TableID of
            DATABASE::Customer:
                UpdateCustGlobalDimCode2(GlobalDimCodeNo, AccNo, NewDimValue);
            DATABASE::Vendor:
                UpdateVendGlobalDimCode2(GlobalDimCodeNo, AccNo, NewDimValue);
            DATABASE::Item:
                UpdateItemGlobalDimCode2(GlobalDimCodeNo, AccNo, NewDimValue);
        end;
    end;

    local procedure UpdateVendGlobalDimCode2(GlobalDimCodeNo: Integer; VendNo: Code[20]; NewDimValue: Code[20])
    var
        Vend: Record Vendor;
    begin
        if Vend.Get(VendNo) then begin
            case GlobalDimCodeNo of
                1:
                    Vend."Global Dimension 1 Code" := NewDimValue;
                2:
                    Vend."Global Dimension 2 Code" := NewDimValue;
                3:
                    Vend."Global Dimension 3 Code" := NewDimValue;
                4:
                    Vend."Global Dimension 4 Code" := NewDimValue;
                5:
                    Vend."Global Dimension 5 Code" := NewDimValue;
                6:
                    Vend."Global Dimension 6 Code" := NewDimValue;
                7:
                    Vend."Global Dimension 7 Code" := NewDimValue;
                8:
                    Vend."Global Dimension 8 Code" := NewDimValue;
                else
            end;
            Vend.Modify(true);
        end;
    end;

    local procedure UpdateCustGlobalDimCode2(GlobalDimCodeNo: Integer; CustNo: Code[20]; NewDimValue: Code[20])
    var
        Cust: Record Customer;
    begin
        if Cust.Get(CustNo) then begin
            case GlobalDimCodeNo of
                1:
                    Cust."Global Dimension 1 Code" := NewDimValue;
                2:
                    Cust."Global Dimension 2 Code" := NewDimValue;
                3:
                    Cust."Global Dimension 3 Code" := NewDimValue;
                4:
                    Cust."Global Dimension 4 Code" := NewDimValue;
                5:
                    Cust."Global Dimension 5 Code" := NewDimValue;
                6:
                    Cust."Global Dimension 6 Code" := NewDimValue;
                7:
                    Cust."Global Dimension 7 Code" := NewDimValue;
                8:
                    Cust."Global Dimension 8 Code" := NewDimValue;
                else
            end;
            Cust.Modify(true);
        end;
    end;

    local procedure UpdateItemGlobalDimCode2(GlobalDimCodeNo: Integer; ItemNo: Code[20]; NewDimValue: Code[20])
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then begin
            case GlobalDimCodeNo of
                1:
                    Item."Global Dimension 1 Code" := NewDimValue;
                2:
                    Item."Global Dimension 2 Code" := NewDimValue;
                3:
                    Item."Global Dimension 3 Code" := NewDimValue;
                4:
                    Item."Global Dimension 4 Code" := NewDimValue;
                5:
                    Item."Global Dimension 5 Code" := NewDimValue;
                6:
                    Item."Global Dimension 6 Code" := NewDimValue;
                7:
                    Item."Global Dimension 7 Code" := NewDimValue;
                8:
                    Item."Global Dimension 8 Code" := NewDimValue;
                else
            end;
            Item.Modify(true);
        end;
    end;

}