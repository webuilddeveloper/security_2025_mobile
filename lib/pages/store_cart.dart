import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/store_order_summary.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  final VoidCallback onCartUpdated;

  CartPage({required this.cartItems, required this.onCartUpdated});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Set<int> selectedItems = {};

  void toggleSelection(int index) {
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
      } else {
        selectedItems.add(index);
      }
    });
  }

  void deleteSelectedItems() {
    setState(() {
      List<int> sortedIndices = selectedItems.toList()
        ..sort((a, b) => b.compareTo(a));
      for (int index in sortedIndices) {
        widget.cartItems.removeAt(index);
      }
      selectedItems.clear();

      // อัปเดตหน้าแรก
      widget.onCartUpdated();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ลบสินค้าที่เลือกออกจากรถเข็นแล้ว"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }

  void updateQuantity(int index, bool increase) {
    setState(() {
      if (increase) {
        if (widget.cartItems[index]['quantity'] <
            widget.cartItems[index]['stock']) {
          widget.cartItems[index]['quantity']++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("ไม่สามารถเพิ่มจำนวนได้ เนื่องจากเกินจำนวนในสต็อก"),
              backgroundColor: Colors.orange[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        if (widget.cartItems[index]['quantity'] > 1) {
          widget.cartItems[index]['quantity']--;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("ลบสินค้า"),
                content: Text("คุณต้องการลบสินค้านี้ออกจากรถเข็นหรือไม่?"),
                actions: [
                  TextButton(
                    child: Text("ยกเลิก"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text(
                      "ลบ",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.cartItems.removeAt(index);
                        selectedItems.remove(index);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cartItems
        .asMap()
        .entries
        .where((entry) => selectedItems.contains(entry.key))
        .fold(
            0,
            (sum, entry) =>
                sum + entry.value['price'] * entry.value['quantity']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFFB03432),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "รถเข็นของฉัน",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: deleteSelectedItems, // ให้สามารถกดได้
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "รถเข็นของคุณว่างเปล่า",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                var item = widget.cartItems[index];
                bool isSelected = selectedItems.contains(index);

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => toggleSelection(index),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) => toggleSelection(index),
                            activeColor: Color(0XFFB03432),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "฿${item['price']}",
                                  style: TextStyle(
                                    color: Color(0XFFB03432),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          _buildQuantityButton(
                                            icon: Icons.remove,
                                            onPressed: () =>
                                                updateQuantity(index, false),
                                          ),
                                          Container(
                                            width: 40,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${item['quantity']}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          _buildQuantityButton(
                                            icon: Icons.add,
                                            onPressed: () =>
                                                updateQuantity(index, true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "คงเหลือ ${item['stock']} ชิ้น",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ยอดรวมทั้งหมด',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '฿${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFB03432),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.cartItems.isEmpty
                    ? null
                    : () {
                        // สร้าง List ใหม่ที่เก็บเฉพาะรายการที่เลือก
                        List<Map<String, dynamic>> selectedCartItems = [];
                        for (int index in selectedItems) {
                          selectedCartItems.add(widget.cartItems[index]);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderSummaryPage(
                              cartItems:
                                  selectedCartItems, // ส่งเฉพาะรายการที่เลือก
                              totalAmount: totalAmount.toInt(),
                            ),
                          ),
                        );
                      },
                child: Text(
                  "ดำเนินการชำระเงิน",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFFB03432),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      minWidth: 32,
      height: 32,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 18,
        color: Color(0XFFB03432),
      ),
    );
  }
}
