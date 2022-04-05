package com.yujin.opgg;

import java.util.Base64;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;



@Controller
public class TestController {
	@RequestMapping("/")
	public String home(){

		return "makeLicense";

	}
}
