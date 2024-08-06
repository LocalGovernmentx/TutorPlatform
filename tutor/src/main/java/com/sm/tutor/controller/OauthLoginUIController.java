package com.sm.tutor.controller;

import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import java.util.Collection;
import java.util.Iterator;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/oauth-login")
public class OauthLoginUIController {

  private final MemberService memberService;

  @GetMapping(value = {"", "/"})
  public String home(Model model) {

    model.addAttribute("loginType", "oauth-login");
    model.addAttribute("pageName", "oauth 로그인");

    String email = SecurityContextHolder.getContext().getAuthentication().getName();
    System.out.println("email = " + email);
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
    Iterator<? extends GrantedAuthority> iter = authorities.iterator();
    GrantedAuthority auth = iter.next();
    String role = auth.getAuthority();

    Member loginMember = memberService.getMemberByEmail(email);

    if (loginMember != null) {
      model.addAttribute("name", loginMember.getName());
    }

    return "home";
  }

  @GetMapping("/login")
  public String loginPage(Model model) {

    model.addAttribute("loginType", "oauth-login");
    model.addAttribute("pageName", "oauth 로그인");
    return "login";
  }

  @GetMapping("/info")
  public String memberInfo(Authentication auth, Model model) {
    model.addAttribute("loginType", "oauth-login");
    model.addAttribute("pageName", "oauth 로그인");

    Member loginMember = memberService.getMemberByEmail(auth.getName());

    model.addAttribute("member", loginMember);
    return "info";
  }
}