<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:forEach var="customer" items="${customers}">
    <tr class="border-b hover:bg-gray-100 transition duration-200">
        <td class="px-4 py-2">${customer.id}</td>
        <td class="px-4 py-2">${customer.name}</td>
        <td class="px-4 py-2">${customer.email}</td>
        <td class="px-4 py-2">${customer.phoneNumber}</td>
        <td class="px-4 py-2 text-indigo-600 font-semibold">${customer.loyaltyPoints}</td>
        <td class="px-4 py-2">
            <button class="editCustomerBtn bg-yellow-500 hover:bg-yellow-600 text-white py-1 px-3 rounded-lg shadow-md"
                    data-customer='{"id":"${customer.id}", "name":"${customer.name}", "email":"${customer.email}", "phoneNumber":"${customer.phoneNumber}", "loyaltyPoints":"${customer.loyaltyPoints}", "version":"${customer.version}"}'>
                ✏️ Edit
            </button>
        </td>
    </tr>
</c:forEach>

<c:if test="${customers == null || customers.isEmpty()}">
    <tr>
        <td colspan="6" class="text-center text-gray-500 py-4">No customers found.</td>
    </tr>
</c:if>

<c:if test="${customers == null || customers.isEmpty()}">
            <tr>
                <td colspan="6">No customers found.</td>
            </tr>
        </c:if>