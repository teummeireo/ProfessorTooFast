<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 	uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" 	uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="sql" 	uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Revenue Sharing DEFI Platform</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #FFBCBC;
            color: white;
            overflow-x: hidden;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 10%;
        }

        .navbar .logo {
            font-size: 1.5em;
            font-weight: bold;
        }

        .navbar .nav-links a {
            text-decoration: none;
            color: white;
            margin: 0 15px;
            font-weight: 500;
        }

        .navbar .launch-btn {
            background-color: #4a007f;
            padding: 10px 20px;
            border-radius: 20px;
            text-decoration: none;
            color: white;
            font-weight: bold;
        }

        .hero {
            text-align: center;
            padding: 80px 10%;
        }

        .hero h1 {
            font-size: 3em;
            margin-bottom: 20px;
        }

        .hero p {
            font-size: 1.2em;
            margin-bottom: 30px;
        }

        .hero .cta-btn {
            background-color: white;
            color: black;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
        }

        .banner {
            background: white;
            color: black;
            text-align: center;
            padding: 10px 0;
            font-weight: bold;
        }

        .cards {
            display: flex;
            justify-content: center;
            gap: 20px;
            padding: 50px 10%;
        }

        .card {
            background-color: #240554;
            padding: 20px;
            border-radius: 10px;
            width: 300px;
            text-align: center;
        }

        .card h3 {
            margin-bottom: 10px;
        }

        .card p {
            margin-bottom: 20px;
        }

        .card a {
            background-color: #6e00b5;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">Origin</div>

        <a href="#" class="launch-btn">Launch App</a>
    </div>

    <div class="hero">
        <h1>강넘빨</h1>
        <p>Your first step to decentralized finance. Raise, Launch, Track and trade all in one place. NFT holders earn a percent of monthly earnings.</p>
        <a href="#" class="cta-btn">View Docs</a>
    </div>

    <div class="banner">
        GET 10% OFF FOR THE FIRST DEAL · GET 10% OFF FOR THE FIRST DEAL · GET 10% OFF FOR THE FIRST DEAL
    </div>

    <div class="cards">
        <div class="card">
            <h3>Launchpad Listing</h3>
            <p>Create an origin pad listing to raise funds for your project. Click the create button below to get started.</p>
            <a href="#">Create Listing</a>
        </div>
        <div class="card">
            <h3>Apply For Integration</h3>
            <p>Project looking to integrate with Origin Labs? Click the button below and fill the form to apply for platform integration.</p>
            <a href="#">Apply Now</a>
        </div>
    </div>
</body>
</html>
