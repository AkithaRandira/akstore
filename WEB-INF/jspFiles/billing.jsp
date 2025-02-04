<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <script type="text/javascript">
            // Creating a JavaScript object to hold Bill details
            var bill = {
                billId: "${bill.billId}",
                customerId: "${bill.customerId}",
                totalAmount: "${bill.totalAmount}",
                cashTendered: "${bill.cashTendered}",
                changeGiven: "${bill.changeGiven}",
                billDate: "${bill.billDate}",
                discountAmount: "${bill.discountAmount}",
                taxAmount: "${bill.taxAmount}",
                finalPrice: "${bill.finalPrice}",
                loyaltyPointsUsed: "${bill.loyaltyPointsUsed}"
            };

            // Logging the bill object to the console
            console.log(bill);
        </script>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Billing System</title>
            <script src="https://cdn.tailwindcss.com"></script>
        </head>

        <body class="bg-gradient-to-br from-indigo-600 to-blue-400 text-white font-sans min-h-screen flex items-center justify-center">
        <div class="max-w-4xl w-full bg-white bg-opacity-10 backdrop-blur-lg shadow-xl rounded-2xl p-10 border border-white border-opacity-20">
        <!-- Back to Main Menu link with arrow -->
            <a href="<c:url value='/' />"
               class="bg-white bg-opacity-30 text-white hover:bg-indigo-600 hover:text-white font-semibold py-3 px-6 rounded-full shadow-lg transition duration-300 inline-flex items-center space-x-2 border border-white border-opacity-50 backdrop-blur-md mb-8">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                     xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M15 19l-7-7 7-7"></path>
                </svg>
                <span>Return to Main Menu</span>
            </a>

            <h2 class="text-3xl font-bold text-gray-900">Billing System</h2>


            <!-- Success/ Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4">
                        ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
                        ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Step 1: Enter Customer Phone Number (Optional) -->
                <c:if test="${empty sessionScope.customerPhone && sessionScope.skipPhone != true}">
                    <h3 class="text-2xl font-semibold mb-4">Enter Customer Phone Number or Skip</h3>
                    <form action="billing" method="post" class="space-y-6 bg-gray-50 p-8 rounded-lg shadow-lg w-full max-w-lg mx-auto">
                          <div class="w-full">

                <label for="customerPhone" class="block text-lg font-semibold text-gray-700">
                                Customer Phone Number:
                            </label>
                              <input type="text" name="customerPhone" id="customerPhone" placeholder="Enter phone number"
                                     class="mt-2 block w-full p-3 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black bg-white bg-opacity-80 placeholder-gray-500">

                          </div>

                        <input type="hidden" name="action" value="1">
                        <input type="hidden" name="operation" value="enterPhoneNumber">
                        <div class="flex justify-between items-center mt-4">
                            <div></div> <!-- Empty div to push buttons to the right -->
                            <div class="flex space-x-3">
                                <button type="submit"
                                        class="bg-indigo-600 hover:bg-indigo-800 text-white font-bold py-2 px-5 rounded-lg shadow-md transition duration-300">
                                    Next
                                </button>
                                <button type="submit" name="skipPhone" value="true"
                                        class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-5 rounded-lg shadow-md transition duration-300">
                                    Skip Phone Number
                                </button>
                            </div>
                        </div>

                    </form>
                </c:if>

                <!-- Show Customer Name if the phone number is entered and customer is found -->
                <c:if test="${not empty sessionScope.customerName}">
                    <h4 class="text-2xl font-semibold mt-6 mb-4">Welcome, ${sessionScope.customerName}</h4>
                </c:if>

                <!-- Step 2: Add Items to the Bill -->
                <c:if test="${not empty sessionScope.customerPhone || sessionScope.skipPhone eq true}">
                    <c:if test="${empty sessionScope.addedItemsDone}">
                        <h3 class="text-2xl font-semibold mb-6">🛒 Add Items to Bill</h3>

                        <form action="billing" method="post" class="bg-white p-8 rounded-xl shadow-md max-w-xl mx-auto space-y-6">
                            <!-- Item Code Input -->
                            <div>
                                <label for="itemCode" class="block text-lg font-medium text-gray-700">🔢 Item Code:</label>
                                <input type="text" name="itemCode" id="itemCode" placeholder="Enter item code"
                                       class="mt-2 block w-full p-3 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black bg-white bg-opacity-80 placeholder-gray-500">
                            </div>

                            <!-- Quantity Input -->
                            <div>
                                <label for="quantity" class="block text-lg font-medium text-gray-700">🔢 Quantity:</label>
                                <input type="number" name="quantity" id="quantity" min="1"
                                       class="mt-2 block w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black caret-black bg-white bg-opacity-80 placeholder-gray-700"
                                       required>
                            </div>

                            <input type="hidden" name="action" value="1">
                            <input type="hidden" name="operation" value="addItem">

                            <!-- Add Item Button -->
                            <div class="flex justify-center">
                                <button type="submit"
                                        class="bg-indigo-600 hover:bg-indigo-800 text-white text-lg font-semibold py-3 px-6 rounded-lg shadow-md transition duration-300 transform hover:scale-105">
                                    ✅ Add Item
                                </button>
                            </div>
                        </form>
                    </c:if>


                <!-- Display Added Items -->
                    <c:if test="${not empty sessionScope.addedItems}">
                        <h4 class="text-2xl font-semibold mt-6 mb-4">🛍️ Current Items in Bill</h4>

                        <div class="overflow-hidden border rounded-lg shadow-md bg-white">
                            <table class="min-w-full bg-white">
                                <!-- Table Header -->
                                <thead>
                                <tr class="bg-indigo-600 text-white text-lg">
                                    <th class="py-3 px-6 text-left">Item Code</th>
                                    <th class="py-3 px-6 text-left">Item Name</th>
                                    <th class="py-3 px-6 text-left">Quantity</th>
                                    <th class="py-3 px-6 text-left">Price</th>
                                    <th class="py-3 px-6 text-center">Actions</th>
                                </tr>
                                </thead>
                                <!-- Table Body -->
                                <tbody class="text-gray-800">
                                <c:forEach var="transaction" items="${sessionScope.addedItems}" varStatus="transactionStatus">
                                    <c:forEach var="itemQuantity" items="${transaction.itemQuantities}">
                                        <tr class="border-b hover:bg-gray-100 transition duration-200">
                                            <!-- Item Details -->
                                            <td class="py-3 px-6">${itemQuantity.item.code}</td>
                                            <td class="py-3 px-6">${itemQuantity.item.name}</td>
                                            <td class="py-3 px-6">${itemQuantity.quantity}</td>
                                            <td class="py-3 px-6">${itemQuantity.item.price}</td>

                                            <!-- Remove Button -->
                                            <td class="py-3 px-6 text-center">
                                                <form action="billing" method="post" class="flex justify-center items-center">
                                                    <input type="hidden" name="action" value="1">
                                                    <input type="hidden" name="operation" value="removeItem">
                                                    <input type="hidden" name="itemCode" value="${itemQuantity.item.code}">
                                                    <input type="hidden" name="transactionIndex" value="${transactionStatus.index}">
                                                    <button type="submit"
                                                            class="bg-red-600 hover:bg-red-800 text-white font-semibold py-2 px-4 rounded-lg shadow-md transition duration-300 transform hover:scale-105 inline-flex items-center">
                                                        Remove
                                                    </button>
                                                </form>
                                            </td>

                                        </tr>
                                    </c:forEach>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>



                    <c:if test="${not empty sessionScope.addedItems}">
                        <form action="billing" method="post" class="mt-6 flex justify-center">
                            <input type="hidden" name="action" value="1">
                            <input type="hidden" name="operation" value="doneAddingItems">
                            <button type="submit"
                                    class="bg-indigo-600 hover:bg-indigo-800 text-white font-bold py-3 px-6 rounded-lg shadow-md transition duration-300 transform hover:scale-105">
                                ✅ Done Adding Items
                            </button>
                        </form>
                    </c:if>

                </c:if>

                <!-- Step 3: Apply Loyalty Points and Discounts -->
                <c:if test="${not empty sessionScope.addedItemsDone && not empty sessionScope.addedItems}">
                    <div class="bg-white p-6 rounded-lg shadow-lg mt-6 max-w-2xl mx-auto">
                        <h3 class="text-2xl font-semibold text-gray-900 mb-4 flex items-center">
                            💰 Apply Discounts & Loyalty Points
                        </h3>

                        <form action="billing" method="post" class="space-y-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- Loyalty Points Input -->
                                <c:if test="${not empty sessionScope.customerPhone && sessionScope.skipPhone != true}">
                                    <div>
                                        <label for="loyaltyPoints" class="block text-lg font-medium text-gray-700">
                                            🎟️ Loyalty Points (Available: ${sessionScope.customerLoyaltyPoints})
                                        </label>
                                        <input type="number" name="loyaltyPoints" id="loyaltyPoints"
                                               placeholder="Enter loyalty points"
                                               value="${sessionScope.loyaltyPoints != null ? loyaltyPoints : '0'}" min="0"
                                               max="${sessionScope.customerLoyaltyPoints}"
                                               class="mt-2 block w-full p-3 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black caret-black bg-white bg-opacity-80 placeholder-gray-700">

                                    </div>
                                </c:if>

                                <!-- Discount Input -->
                                <div>
                                    <label for="discountRate" class="block text-lg font-medium text-gray-700">🏷️ Discount Rate (0-100%)</label>
                                    <input type="number" name="discountRate" id="discountRate"
                                           placeholder="Enter discount rate"
                                           value="${sessionScope.discountRate != null ? discountRate : '0'}" min="0" max="100"
                                           required
                                           class="mt-2 block w-full p-3 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black caret-black bg-white bg-opacity-80 placeholder-gray-700">

                                </div>
                            </div>

                            <input type="hidden" name="action" value="1">
                            <input type="hidden" name="operation" value="applyDiscountAndLoyaltyPoints">

                            <div class="flex justify-center mt-4">
                                <button type="submit"
                                        class="bg-indigo-600 hover:bg-indigo-800 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition duration-300 transform hover:scale-105">
                                    ✅ Apply Discounts
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>



                <!-- Step 4: Display Total and Enter Cash Received -->
                <c:if test="${not empty sessionScope.discountsApplied && empty sessionScope.errorMessage
    && sessionScope.finalAmount > 0 && not empty sessionScope.addedItemsDone && not empty sessionScope.addedItems}">
                    <div class="bg-white p-6 rounded-lg shadow-lg mt-6 max-w-2xl mx-auto">
                        <h3 class="text-2xl font-semibold text-gray-900 mb-4 flex items-center justify-between">
                            💵 Total Amount: <span class="text-indigo-600 font-bold text-3xl">${sessionScope.finalAmount}</span>
                        </h3>

                        <form action="billing" method="post" class="space-y-6">
                            <div>
                                <label for="cashReceived" class="block text-lg font-medium text-gray-700">
                                    💰 Cash Received:
                                </label>
                                <input type="number" name="cashReceived" id="cashReceived"
                                       placeholder="Enter cash received"
                                       value="${sessionScope.cashReceived}"
                                       class="mt-2 block w-full p-3 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black caret-black bg-white bg-opacity-80 placeholder-gray-700 shadow-sm"
                                       required>

                            </div>
                            <input type="hidden" name="action" value="1">
                            <input type="hidden" name="operation" value="calculateChange">

                            <div class="flex justify-center mt-4">
                                <button type="submit"
                                        class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition duration-300 transform hover:scale-105">
                                    💲 Calculate Change
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>


                <!-- Step 5: Display Change and Finalize Transaction -->
                <c:if test="${not empty sessionScope.changeAmount && not empty sessionScope.addedItems
    && not empty sessionScope.addedItemsDone && not empty sessionScope.bill}">
                    <div class="bg-white p-8 rounded-lg shadow-lg mt-6 max-w-3xl mx-auto">
                        <h3 class="text-2xl font-semibold text-gray-900 mb-4 flex items-center justify-between">
                            💰 Change to Return:
                            <span class="text-green-600 font-bold text-3xl">${sessionScope.changeAmount}</span>
                        </h3>

                        <!-- Bill Details -->
                        <div class="bg-gray-100 p-6 rounded-lg shadow-md mt-4">
                            <h3 class="text-2xl font-bold text-gray-800 flex items-center">
                                🧾 SYOS Bill Details
                            </h3>

                            <!-- Customer Information -->
                            <div class="mt-4">
                                <p class="text-lg text-black"><strong>👤 Customer:</strong> ${sessionScope.customerName}</p>
                                <p class="text-lg text-black"><strong>📅 Date:</strong> ${sessionScope.bill.formattedBillDate}</p>
                            </div>


                            <!-- Items Purchased Table -->
                            <h4 class="text-xl font-semibold mt-6 mb-4 text-gray-700">🛒 Items Purchased</h4>
                            <div class="overflow-hidden border rounded-lg shadow-sm">
                                <table class="min-w-full bg-white">
                                    <thead class="bg-indigo-600 text-white">
                                    <tr>
                                        <th class="py-3 px-6 text-left text-lg">Item Code</th>
                                        <th class="py-3 px-6 text-left text-lg">Item Name</th>
                                        <th class="py-3 px-6 text-center text-lg">Quantity</th>
                                        <th class="py-3 px-6 text-right text-lg">Total Price</th>
                                    </tr>
                                    </thead>
                                    <tbody class="text-gray-800">
                                    <c:forEach var="transaction" items="${sessionScope.bill.transactions}">
                                        <c:forEach var="itemQuantity" items="${transaction.items}">
                                            <tr class="border-b hover:bg-gray-100">
                                                <td class="py-3 px-6">${itemQuantity.item.code}</td>
                                                <td class="py-3 px-6">${itemQuantity.item.name}</td>
                                                <td class="py-3 px-6 text-center">${itemQuantity.quantity}</td>
                                                <td class="py-3 px-6 text-right">${itemQuantity.item.price * itemQuantity.quantity}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Finalize Transaction Button -->
                        <form action="billing" method="post">
                            <input type="hidden" name="action" value="1">
                            <input type="hidden" name="operation" value="finalizeTransaction">
                            <div class="flex justify-center mt-6">
                                <button type="submit"
                                        class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition duration-300 transform hover:scale-105">
                                    ✅ Finalize and Save Transaction
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>


                <!-- Exit Billing -->


                <!-- Cancel Billing Button with Modern Alert -->
                <c:if test="${not empty sessionScope.addedItems || not empty sessionScope.addedItemsDone}">
                    <form action="billing" method="post" id="cancelBillingForm" class="mt-6">
                        <input type="hidden" name="action" value="1">
                        <input type="hidden" name="operation" value="exitBilling">
                        <div class="flex justify-center">
                            <button type="button" onclick="confirmCancel()"
                                    class="bg-red-600 hover:bg-red-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition duration-300 transform hover:scale-105 flex items-center">
                                Cancel Billing
                            </button>
                        </div>
                    </form>
                </c:if>


                <!-- Include SweetAlert2 Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <!-- JavaScript Confirmation -->
                <script>
                    function confirmCancel() {
                        Swal.fire({
                            title: "Are you sure?",
                            text: "All progress will be lost if you cancel this billing process.",
                            icon: "warning",
                            showCancelButton: true,
                            confirmButtonColor: "#d33",
                            cancelButtonColor: "#3085d6",
                            confirmButtonText: "Yes, Cancel!",
                            cancelButtonText: "No, Go Back"
                        }).then((result) => {
                            if (result.isConfirmed) {
                                document.getElementById("cancelBillingForm").submit();
                            }
                        });
                    }
                </script>


            </div>
        </body>

        </html>